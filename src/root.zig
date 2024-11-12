const std = @import("std");
const remote_input = @import("remote-input.zig");

pub const RemoteInput = extern struct {
    handle: c_int,
};

pub export fn RemoteInput_init(ctx: *RemoteInput, name: [*:0]const u8, port: u16) c_int {
    const n = std.mem.sliceTo(name, 0);
    const remoteInput = remote_input.RemoteInput.init(n, port) catch |err| {
        std.debug.print("RemoteInput_init Error: {}\n", .{err});
        return @intFromError(err);
    };

    ctx.handle = remoteInput.stream.handle;

    return 0;
}

pub export fn RemoteInput_deinit(ctx: *RemoteInput) void {
    const remoteInput = remote_input.RemoteInput{ .stream = .{ .handle = ctx.handle } };
    remoteInput.deinit();
}

pub export fn RemoteInput_move_x(ctx: *RemoteInput, x: i32) void {
    const remoteInput = remote_input.RemoteInput{ .stream = .{ .handle = ctx.handle } };
    remoteInput.move_x(x) catch |err| {
        std.debug.print("RemoteInput_move_x Error: {}\n", .{err});
    };
}

pub export fn RemoteInput_move_y(ctx: *RemoteInput, y: i32) void {
    const remoteInput = remote_input.RemoteInput{ .stream = .{ .handle = ctx.handle } };
    remoteInput.move_y(y) catch |err| {
        std.debug.print("RemoteInput_move_y Error: {}\n", .{err});
    };
}

pub export fn RemoteInput_press(ctx: *RemoteInput, key: u16) void {
    const remoteInput = remote_input.RemoteInput{ .stream = .{ .handle = ctx.handle } };
    remoteInput.press(@enumFromInt(key)) catch |err| {
        std.debug.print("RemoteInput_press Error: {}\n", .{err});
    };
}

pub export fn RemoteInput_release(ctx: *RemoteInput, key: u16) void {
    const remoteInput = remote_input.RemoteInput{ .stream = .{ .handle = ctx.handle } };
    remoteInput.release(@enumFromInt(key)) catch |err| {
        std.debug.print("RemoteInput_release Error: {}\n", .{err});
    };
}

pub export fn RemoteInput_type(ctx: *RemoteInput, c_text: [*:0]const u8) void {
    const text = std.mem.sliceTo(c_text, 0);

    for (text) |char| {
        RemoteInput_char(ctx, char);
    }
}

pub export fn RemoteInput_char(ctx: *RemoteInput, char: u8) void {
    const remoteInput = remote_input.RemoteInput{ .stream = .{ .handle = ctx.handle } };
    remoteInput.char(char) catch |err| {
        std.debug.print("RemoteInput_char Error: {}\n", .{err});
    };
}
