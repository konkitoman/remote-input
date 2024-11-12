const std = @import("std");
const print = std.debug.print;
const remote_input = @import("remote-input.zig");

pub fn main() !void {
    var args = std.process.args();
    _ = args.next();
    const address_str = args.next() orelse {
        print("No address specified\n", .{});
        return;
    };
    const port_str = args.next() orelse {
        print("No port specified\n", .{});
        return;
    };

    var port: u16 = 0;
    for (port_str) |ch| {
        if (ch >= '0' and ch <= '9') {
            port = (port * 10) + ch - '0';
        } else {
            return error.InvalidPort;
        }
    }

    const remoteInput = try remote_input.RemoteInput.init(address_str, port);
    defer remoteInput.deinit();
    print("Connected\n", .{});
    const stdin = std.io.getStdIn();
    var buffer: [1024]u8 = undefined;

    while (true) {
        print(">", .{});

        const len = try stdin.read(&buffer);
        const slice = buffer[0..len];
        if (std.mem.indexOfAny(u8, slice, " \n")) |pos| {
            const cmd = slice[0..pos];
            if (std.mem.eql(u8, cmd, "quit")) {
                print("Quiting...\n", .{});
                return;
            } else if (std.mem.eql(u8, cmd, "type")) {
                if (std.mem.indexOf(u8, slice, "\n")) |start| {
                    const text = slice[pos + 1 .. start];
                    try remoteInput.ty(text);
                }
            } else {
                print("Invalid command\n", .{});
            }
        }
    }
}
