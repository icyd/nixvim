-- Requires {{{
local ts_utils = require("nvim-treesitter.ts_utils")
local ts_locals = require("nvim-treesitter.locals")
local f = require("luasnip").function_node
local rep = require("luasnip.extras").rep
local ai = require("luasnip.nodes.absolute_indexer")
--}}}

---Transform makes a node from the given text.
local function transform(text, info) --{{{
    local string_sn = function(template, default)
        info.index = info.index + 1
        return sn(info.index, fmt(template, i(1, default)))
    end
    local new_sn = function(default)
        return string_sn("{}", default)
    end

    -- cutting the name if exists.
    if text:find([[^[^\[]*string$]]) then
        text = "string"
    elseif text:find("^[^%[]*map%[[^%]]+") then
        text = "map"
    elseif text:find("%[%]") then
        text = "slice"
    elseif text:find([[ ?chan +[%a%d]+]]) then
        return t("nil")
    end

    -- separating the type from the name if exists.
    local type = text:match([[^[%a%d]+ ([%a%d]+)$]])
    if type then
        text = type
    end

    if text == "int" or text == "int64" or text == "int32" then
        return new_sn("0")
    elseif text == "float32" or text == "float64" then
        return new_sn("0")
    elseif text == "error" then
        if not info then
            return t("err")
        end

        info.index = info.index + 1
        return c(info.index, {
            sn(nil, fmt('errors.Wrap({}, "{}")', { t(info.err_name), i(1) })),
            sn(nil, fmt('errors.Wrapf({}, "{}", {})', { t(info.err_name), i(1), i(2) })),
            sn(
                nil,
                fmt('internal.GrpcError({},\n\t\tcodes.{}, "{}", "{}", {})', {
                    t(info.err_name),
                    i(1, "Internal"),
                    i(2, "Description"),
                    i(3, "Field"),
                    i(4, "fields"),
                })
            ),
            t(info.err_name),
        })
    elseif text == "bool" then
        info.index = info.index + 1
        return c(info.index, { i(1, "false"), i(2, "true") })
    elseif text == "string" then
        return string_sn('"{}"', "")
    elseif text == "map" or text == "slice" then
        return t("nil")
    elseif string.find(text, "*", 1, true) then
        return new_sn("nil")
    end

    text = text:match("[^ ]+$")
    if text == "context.Context" then
        text = "context.Background()"
    else
        -- when the type is concrete
        text = text .. "{}"
    end

    return t(text)
end --}}}

local get_node_text = vim.treesitter.get_node_text
local handlers = { --{{{
    parameter_list = function(node, info)
        local result = {}

        local count = node:named_child_count()
        for idx = 0, count - 1 do
            table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
            if idx ~= count - 1 then
                table.insert(result, t({ ", " }))
            end
        end

        return result
    end,

    type_identifier = function(node, info)
        local text = get_node_text(node, 0)
        return { transform(text, info) }
    end,
} --}}}

vim.treesitter.query.set( --{{{
    "go",
    "LuaSnip_Result",
    [[
    [
      (method_declaration result: (_) @id)
      (function_declaration result: (_) @id)
      (func_literal result: (_) @id)
    ]
  ]]
) --}}}

local function return_value_nodes(info) --{{{
    local cursor_node = ts_utils.get_node_at_cursor()
    local scope_tree = ts_locals.get_scope_tree(cursor_node, 0)

    local function_node
    for _, scope in ipairs(scope_tree) do
        if
            scope:type() == "function_declaration"
            or scope:type() == "method_declaration"
            or scope:type() == "func_literal"
        then
            function_node = scope
            break
        end
    end

    if not function_node then
        return
    end

    local query = vim.treesitter.get_query("go", "LuaSnip_Result")
    for _, node in query:iter_captures(function_node, 0) do
        if handlers[node:type()] then
            return handlers[node:type()](node, info)
        end
    end
end --}}}

local M = {}

---Transforms the given arguments into nodes wrapped in a snippet node.
M.make_return_nodes = function(args) --{{{
    local info = { index = 0, err_name = args[1][1] }
    return sn(nil, return_value_nodes(info))
end --}}}

---Runs the command in shell.
-- @param command string
-- @return table
M.shell = function(command) --{{{
    local file = io.popen(command, "r")
    local res = {}
    for line in file:lines() do
        table.insert(res, line)
    end
    return res
end --}}}

M.last_lua_module_section = function(args) --{{{
    local text = args[1][1] or ""
    local split = vim.split(text, ".", { plain = true })

    local options = {}
    for len = 0, #split - 1 do
        local node = t(table.concat(vim.list_slice(split, #split - len, #split), "_"))
        table.insert(options, node)
    end

    return sn(nil, {
        c(1, options),
    })
end --}}}

---Returns true if the cursor in a function body.
-- @return boolean
function M.is_in_function() --{{{
    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then
        return false
    end
    local expr = current_node

    while expr do
        if expr:type() == "function_declaration" or expr:type() == "method_declaration" then
            return true
        end
        expr = expr:parent()
    end
    return false
end --}}}

---Returns true if the cursor in a test file.
-- @return boolean
function M.is_in_test_file() --{{{
    local filename = vim.fn.expand("%:p")
    return vim.endswith(filename, "_test.go")
end --}}}

---Returns true if the cursor in a function body in a test file.
-- @return boolean
function M.is_in_test_function() --{{{
    return M.is_in_test_file() and M.is_in_function()
end --}}}

math.randomseed(os.time())
M.uuid = function() --{{{
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    local out
    local function subs(c)
        local v = (((c == "x") and math.random(0, 15)) or math.random(8, 11))
        return string.format("%x", v)
    end

    out = template:gsub("[xy]", subs)
    return out
end --}}}

local charset = {} -- Random String {{{
for i = 48, 57 do
    table.insert(charset, string.char(i))
end
for i = 65, 90 do
    table.insert(charset, string.char(i))
end
for i = 97, 122 do
    table.insert(charset, string.char(i))
end
M.random_string = function(length)
    if length == 0 then
        return ""
    end
    return M.random_string(length - 1) .. charset[math.random(1, #charset)]
end --}}}

M.snake_case = function(titlecase) --{{{
    -- lowercase the first letter otherwise it causes the result to start with an
    -- underscore.
    titlecase = string.lower(string.sub(titlecase, 1, 1)) .. string.sub(titlecase, 2)
    return titlecase:gsub("%u", function(c)
        return "_" .. c:lower()
    end)
end --}}}

M.capitalize = function(str)
    return string.gsub(str, "^%l", string.upper)
end

M.camel_case = function(str)
    return string.gsub(str, "%W+(%w+)", M.capitalize)
end

M.upper_camel_case = function(str)
    return string.gsub(str, "%W*(%w+)", M.capitalize)
end

M.create_t_run = function(args) --{{{
    return c(1, {
        t({ "" }),
        sn(
            nil,
            fmt('\tt.Run("{}", {}{})\n{}', {
                i(1, "Case"),
                t(args[1]),
                rep(1),
                d(2, M.create_t_run, ai[1]),
            })
        ),
    })
end --}}}

M.mirror_t_run_funcs = function(args) --{{{
    local strs = {}
    for _, v in ipairs(args[1]) do
        local name = v:match('^%s*t%.Run%s*%(%s*".*", (.*)%)')
        if name then
            local node = string.format("func %s(t *testing.T) {{\n\tt.Parallel()\n}}\n\n", name)
            table.insert(strs, node)
        end
    end
    local str = table.concat(strs, "")
    if #str == 0 then
        return t("")
    end
    return sn(nil, fmt(str, {}))
end --}}}

-- M.same = function(index)
--     return f(function(args)
--         return args[1]
--     end, { index })
-- end

return M
