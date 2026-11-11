local pinyin_parts = require("flash-any.pinyin.parts")

local default_fuzzy = {
	initials = { { "zh", "z" }, { "ch", "c" }, { "sh", "s" } },
	finals = { { "ang", "an" }, { "eng", "en" }, { "ing", "in" } },
}

---把分组索引为“声母/韵母 → 候选数组”；重叠时保留第一个分组，未分组仅保留自身。
---@param groups? string[][]
---@param parts table<string, string> 音节到声母或韵母的映射
---@return table<string, string[]>
local function fuzzy_index(groups, parts)
	assert(groups == nil or (type(groups) == "table" and vim.islist(groups)), "fuzzy groups must be arrays")
	local ret = {}
	for _, group in ipairs(groups or {}) do
		assert(type(group) == "table" and vim.islist(group), "each fuzzy group must be an array")
		for _, value in ipairs(group) do
			assert(type(value) == "string" and not value:find("[\128-\255]"), "fuzzy components must be ASCII strings")
			if not ret[value] then
				ret[value] = group
			end
		end
	end
	for _, value in pairs(parts) do
		if not ret[value] then
			ret[value] = { value }
		end
	end
	return ret
end

---全拼和双拼均按音节共享拼写；逐字码表由核心读取。
---opts.scheme 省略时使用全拼，字表只保存标准读音。
---@param opts? table scheme 选择双拼方案，fuzzy 控制声母、韵母及最终编码的模糊分组。
---@return FlashAnySourceDefinition
return function(opts)
	local scheme = opts and opts.scheme
	local fuzzy = opts and opts.fuzzy
	assert(fuzzy == nil or type(fuzzy) == "boolean" or type(fuzzy) == "table", "fuzzy must be a boolean or table")
	local rules = scheme
		and assert(require("flash-any.pinyin.schemes")[scheme], "unknown pinyin scheme: " .. tostring(scheme))
	local groups
	if fuzzy == true then
		groups = default_fuzzy
	elseif type(fuzzy) == "table" then
		groups = fuzzy
	end
	-- 分组只读；每次构建创建声母、韵母的反向索引。
	local initial_index = fuzzy_index(groups and groups.initials, pinyin_parts.initial)
	local final_index = fuzzy_index(groups and groups.finals, pinyin_parts.final)
	local code_index = groups and groups.codes ~= nil and fuzzy_index(groups.codes, {})
	for code in pairs(code_index or {}) do
		assert(#code > 0, "fuzzy codes must not be empty")
	end
	---把一个字符的读音转为双拼编码；标点原样保留。
	---@param syllables? string[]
	---@return string[]? 无可用编码时返回 nil。
	local function convert(syllables)
		if not syllables then
			return nil
		end
		local ret = {}
		for _, syllable in ipairs(syllables) do
			local initial, final = pinyin_parts.initial[syllable], pinyin_parts.final[syllable]
			local direct = rules and rules.syllables and rules.syllables[syllable]
			if initial == nil then
				-- Punctuation is already encoded in the table; schemes only convert syllables.
				ret[#ret + 1] = syllable
			elseif direct then
				-- Zero-initial and scheme-specific exceptions take precedence.
				vim.list_extend(ret, direct)
			else
				-- 拆音表覆盖内置拼音的全部音节，直接查询 ASCII 声母、韵母。
				for _, initial_variant in ipairs(initial_index[initial]) do
					if not rules then
						for _, final_variant in ipairs(final_index[final]) do
							ret[#ret + 1] = initial_variant .. final_variant
						end
					else
						for _, first in ipairs(rules.initials[initial_variant] or {}) do
							for _, final_variant in ipairs(final_index[final]) do
								for _, last in ipairs(rules.finals[final_variant] or {}) do
									ret[#ret + 1] = first .. last
								end
							end
						end
					end
				end
			end
		end
		if code_index then
			-- 整码分组作用于最终拼写，仅展开一次，不递归替换或匹配子串。
			local spellings, seen = {}, {}
			for _, code in ipairs(ret) do
				for _, variant in ipairs(code_index[code] or { code }) do
					if not seen[variant] then
						spellings[#spellings + 1], seen[variant] = variant, true
					end
				end
			end
			ret = spellings
		end
		return #ret > 0 and ret or nil
	end
	local syllables = {}
	for syllable in pairs(pinyin_parts.initial) do
		syllables[syllable] = convert({ syllable }) or {}
	end
	return {
		file = assert(vim.api.nvim_get_runtime_file("lua/flash-any/tables/pinyin.tsv", false)[1]),
		format = "tsv",
		columns = { "text", "code" },
		groups = syllables,
		matcher = scheme and "full_code" or "initial",
	}
end
