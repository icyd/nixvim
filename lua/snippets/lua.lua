return {
    s(
        "localreq",
        fmt([[local {} = require("{}")]], {
            l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
            i(1, "module"),
        })
    ),
    s(
        "mfn",
        c(1, {
            fmt("function {}.{}({})\n    {}\nend", {
                i(1),
                i(2),
                i(3),
                i(0),
            }),
            fmt("function {}:{}({})\n    {}\nend", {
                i(1),
                i(2),
                i(3),
                i(0),
            }),
        })
    ),
},
    nil
