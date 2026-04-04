return {
    s(
        "inter",
        fmta(
            [[
public interface <> <>{
	<>
}
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
        fmta(
            [[
public class <> <>{
	<>
}
]],
            {
                l(l.TM_FILENAME:match("^(.+)%..+"), {}),
                i(1),
                i(0),
            }
        )
    ),
}
