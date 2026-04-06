local all_snippets = {
    s(
        "dt",
        f(function()
            return os.date("%D - %H:%M")
        end)
    ),
}

local vars = {
    email = vim.g.snips_email or "email",
    real_name = vim.g.snips_author or "realname",
}
vars.username = string.match(vars.email, "(.+)@") or "username"

--- Get the comment string {beg,end} table
---@return table comment_strings {begcstring, endcstring}
local get_cstring = function()
    local cstring = vim.bo.commentstring
    local left, right = string.match(cstring, "(.*)%%s(.*)")
    if not (right == nil or right == "") then
        right = " " .. right
    end

    return { vim.trim(left or ""), vim.trim(right or "") }
end
---- Options for marks to be used in a TODO comment
local marks = {
    date_signature_with_email = function()
        return fmt("<{}{}>", { i(1, os.date("%y-%m-%d")), i(2, ", " .. vars.email) })
    end,
    date_signature_with_username = function()
        return fmt("<{}{}>", { i(1, os.date("%d-%m-%y")), i(2, ", " .. vars.username) })
    end,
    date_signature_with_name = function()
        return fmt("<{}{}>", { i(1, os.date("%d-%m-%y")), i(2, ", " .. vars.real_name) })
    end,
    date_signature_with_username_and_email = function()
        return fmt("<{}{}{}>", {
            i(1, os.date("%d-%m-%y")),
            i(2, ", " .. vars.username),
            i(3, " " .. vars.email),
        })
    end,
    date = function()
        return fmt("<{}>", i(1, os.date("%d-%m-%y")))
    end,
    empty = function()
        return t("")
    end,
}

local todo_snippet_nodes = function(aliases)
    local aliases_nodes = vim.tbl_map(function(alias)
        return i(nil, alias) -- generate choices for [name-of-comment]
    end, aliases)
    local sigmark_nodes = {} -- choices for [comment-mark]
    for _, mark in pairs(marks) do
        table.insert(sigmark_nodes, mark())
    end
    -- format them into the actual snippet
    local comment_node = fmt("{} {}: {} {}{}{}", {
        f(function()
            return get_cstring()[1]
        end),
        c(1, aliases_nodes), -- [name-of-comment]
        i(3), -- {comment-text}
        c(2, sigmark_nodes), -- [comment-mark]
        f(function()
            return get_cstring()[2]
        end),
        i(0),
    })

    return comment_node
end

--- Generate a TODO comment snippet with an automatic description and docstring
---@param context table merged with the generated context table `trig` must be specified
---@param aliases string[]|string of aliases for the todo comment (ex.: {FIX, ISSUE, FIXIT, BUG})
---@param opts table merged with the snippet opts table
local todo_snippet = function(context, aliases, opts)
    opts = opts or {}
    aliases = type(aliases) == "string" and { aliases } or aliases -- if we do not have aliases, be smart about the function parameters
    context = context or {}
    if not context.trig then
        return error("context doesn't include a `trig` key which is mandatory", 2) -- all we need from the context is the trigger
    end
    local alias_string = table.concat(aliases, "|") -- `choice_node` documentation
    context.name = context.name or (alias_string .. " comment") -- generate the `name` of the snippet if not defined
    context.dscr = context.dscr or (alias_string .. " comment with a signature-mark") -- generate the `dscr` if not defined
    context.docstring = context.docstring or (" {1:" .. alias_string .. "}: {3} <{2:mark}>{0} ") -- generate the `docstring` if not defined
    local comment_node = todo_snippet_nodes(aliases) -- nodes from the previously defined function for their generation
    return s(context, comment_node, opts) -- the final todo-snippet constructed from our parameters
end

local todo_snippet_specs = {
    { { trig = "todo" }, "TODO" },
    { { trig = "fix" }, { "FIX", "BUG", "ISSUE", "FIXIT" } },
    { { trig = "hack" }, "HACK" },
    { { trig = "warn" }, { "WARN", "WARNING", "XXX" } },
    { { trig = "perf" }, { "PERF", "PERFORMANCE", "OPTIM", "OPTIMIZE" } },
    { { trig = "note" }, { "NOTE", "INFO" } },
}

local todo_comment_snippets = {}
for _, v in ipairs(todo_snippet_specs) do
    -- NOTE: 3rd argument accepts nil
    table.insert(todo_comment_snippets, todo_snippet(v[1], v[2], v[3]))
end

for _, v in pairs(todo_comment_snippets) do
    table.insert(all_snippets, v)
end
-- end

return all_snippets, nil
