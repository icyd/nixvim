return {
    s("std", { t([[const std = @import("std");]]) }),
    s(
        "main",
        fmta(
            [[pub fn main() <> {
    <>
}]],
            {
                c(1, { t("void"), t("!void") }),
                i(0),
            }
        )
    ),
    s(
        "debug",
        fmta([[std.debug.print("<>\n", .{<>});]], {
            i(1),
            i(0),
        })
    ),
    s(
        "test",
        fmta(
            [[test "<>" {
    <>
}]],
            {
                i(1),
                i(0),
            }
        )
    ),
}
