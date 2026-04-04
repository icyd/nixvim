-- Requires {{{
local pascalcase = require("luasnip.util.str").vscode_string_modifiers.pascalcase
--}}}
--

local result_choices = function(args)
    -- local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    -- for _, line in ipairs(lines) do
    --     if line:match("^use.*Result") then
    --         table.insert(nodes, fmt(" -> Result<{}> ", i(1)))
    --         break
    --     end
    -- end
    return sn(
        nil,
        c(1, {
            t(" "),
            fmt(" -> {} ", i(1, "T")),
            fmt(" -> Option<{}> ", i(1)),
            fmt(" -> Result<{}> ", i(1)),
            fmt(" -> impl {} ", i(1, "Trait")),
            fmt(" -> Box<dyn {}> ", i(1, "Trait")),
            t(" -> ! "),
        })
    )
end

return {
    s("dervd", t("#derive(Debug)")),
    s("deadcode", t("#[allow(dead_code)]")),
    s("allowfreedom", t("#![allow(clippy::disallowed_name, unused_variables, dead_code)]")),
    s("clippypedantic", t("#![warn(clippy::all, clippy::pedantic)]")),
    s(":tf", { t("::<"), i(1), t(">"), i(0) }),
    s({ trig = "clippylint", desc = "Clippy lint" }, {
        t("#["),
        c(1, { t("allow"), t("deny"), t("warn") }),
        t("("),
        c(2, {
            t("clippy::all"),
            t("clippy::cargo"),
            t("clippy::complexity"),
            t("clippy::correctness"),
            t("clippy::nursery"),
            t("clippy::pedantic"),
            t("clippy::perf"),
            t("clippy::style"),
            t("clippy::suspicious"),
        }),
        t(")]"),
    }),
    s(
        "plnd",
        fmt([[println!("{}: {}", {});{}]], {
            rep(1),
            c(2, { t("{:?}"), t("{:#?}") }),
            i(1),
            i(0),
        })
    ),
    s("pln2", fmt([[println!("{} {}", {});]], { i(1), t("{:?}"), i(0) })),
    s(
        "modtest",
        fmta(
            [[
#[cfg(test)]
mod test {
use super::*;
    <>
}
]],
            i(0)
        )
    ),
    s(
        "test2",
        fmta(
            [[
  #[test]
  fn <>()<>{
      <>
  }
  ]],
            {
                i(1, "testname"),
                d(2, result_choices, {}),
                i(0),
            }
        )
    ),
    s(
        "fn2",
        fmta(
            [[
<>fn <>()<>{
    <>
}
]],
            {
                i(3, "pub "),
                i(1, "name"),
                d(2, result_choices, {}),
                i(0, "todo!();"),
            }
        )
    ),
    s("eq", fmt("assert_eq!({}, {});{}", { i(1), i(2), i(0) })),
    s("pln", fmt([[println!("{}");{}]], { i(1), i(0) })),
    s(
        "fns",
        fmta(
            [[
<>fn <>(<><>)<> {
    <>
}]],
            {
                i(4, "pub "),
                i(1, "Name"),
                c(2, { t("&self "), t("&mut self ") }),
                i(3),
                d(5, result_choices, {}),
                i(0, "todo!();"),
            }
        )
    ),
    s(
        "str-impl",
        fmta(
            [[
<>
<>struct <> {
    <>
}

impl <> {
    <>fn new(<><>) -> Self {
        Self {
            <>
        }
    }<>
}]],
            {
                c(4, { t(""), fmt("#[derive({})]", i(1, "Debug")) }),
                i(3, "pub "),
                i(2, "name"),
                i(1),
                rep(2),
                i(7, "pub "),
                c(5, { t("&self"), t("&mut self") }),
                i(6, ", "),
                i(8, "todo!();"),
                i(0),
            }
        )
    ),
    s(
        "use",
        fmt([[{}use {}::{};{}]], {
            i(1),
            d(2, function(args)
                return sn(nil, { i(1, pascalcase(args[1][1])) })
            end, { 1 }),
            i(3, "pub "),
            i(0),
        })
    ),
}
