return {
    s(
        "inter",
        fmt(
            [[
public interface {} {}{{
	{}
}}
]],
            {
                l(l.TM_FILENAME:match("^(.+)%..+"), {}),
                i(1),
                i(0),
            }
        )
    ),
    s(
        "clas", -- typos:disable-line
        fmt(
            [[
public class {} {}{{
	{}
}}
]],
            {
                l(l.TM_FILENAME:match("^(.+)%..+"), {}),
                i(1),
                i(0),
            }
        )
    ),
}
