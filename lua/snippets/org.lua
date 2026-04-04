local extras = require("luasnip.extras")

local vars = {
    email = vim.g.snips_email or "email",
    real_name = vim.g.snips_author or "realname",
}

return {
    s(
        "code",
        fmt(
            [[
#+BEGIN_SRC {}
    {}
#+END_SRC
]],
            {
                i(1),
                i(0),
            }
        )
    ),
    s(
        "metadata",
        fmt(
            [[
#+TITLE: {}
#+AUTHOR: {}
#+DATE: {}
#+EMAIL: {}
]],
            {
                i(0),
                i(1, vars.real_name),
                extras.partial(os.date, "%Y-%m-%d"),
                i(2, vars.email),
            }
        )
    ),
}
