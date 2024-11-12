const std = @import("std");
const uinput = @import("uinput.zig");
const print = std.debug.print;
const remote_input = @import("remote-input.zig");

const Epoll = @import("epoll.zig");

const Allocator = std.mem.Allocator;

const Connection = struct {
    addr: std.net.Address,
    stream: std.net.Stream,
    device: uinput.Device,
};

fn create_device() !uinput.Device {
    var name = std.mem.zeroes([80:0]u8);
    std.mem.copyForwards(u8, &name, "remote-input");
    return try uinput.Device.init(.{ .name = name, .keyboard = true, .keys = &.{ .KEY_0, .KEY_1, .KEY_2, .KEY_3, .KEY_4, .KEY_5, .KEY_6, .KEY_7, .KEY_8, .KEY_9, .KEY_A, .KEY_B, .KEY_C, .KEY_D, .KEY_E, .KEY_F, .KEY_G, .KEY_H, .KEY_I, .KEY_J, .KEY_K, .KEY_L, .KEY_M, .KEY_N, .KEY_O, .KEY_P, .KEY_Q, .KEY_R, .KEY_S, .KEY_T, .KEY_U, .KEY_V, .KEY_W, .KEY_X, .KEY_Y, .KEY_Z, .KEY_SPACE, .KEY_BACKSPACE, .KEY_LEFTSHIFT, .KEY_ENTER, .KEY_COMMA, .KEY_DOT, .KEY_SLASH, .KEY_SEMICOLON, .KEY_APOSTROPHE, .BTN_LEFT, .BTN_RIGHT } });
}

pub fn main() !void {
    // Test if the device can be created
    {
        var device = try create_device();
        device.deinit();
    }

    const addr = std.net.Address.initIp4(.{ 0, 0, 0, 0 }, 2120);
    var server = try addr.listen(.{});
    print("Listening on {}\n", .{addr});

    var epoll = try Epoll.init(0);
    defer epoll.deinit();

    try epoll.add(server.stream.handle, &.{ .events = Epoll.Events.init(.{ .POLLIN = true }), .data = .{ .fd = 0 } });

    var events: [8]Epoll.Event = undefined;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();

    const alloc = arena.allocator();

    var buffer: [4096]u8 = undefined;

    while (true) {
        const len = try epoll.wait(&events, -1);
        for (events[0..len]) |event| {
            if (event.events.contains(.POLLIN)) {
                if (event.data.fd == 0) {
                    try new_connection(&server, &epoll, alloc);
                    continue;
                }

                try handle_connection(alloc, event, &buffer, &epoll);
            }
        }
    }
}

fn new_connection(server: *std.net.Server, epoll: *Epoll, alloc: Allocator) !void {
    if (server.accept()) |conn| {
        print("Connection from: {}\n", .{conn.address});
        const connection = try alloc.create(Connection);
        connection.addr = conn.address;
        connection.stream = conn.stream;
        connection.device = try create_device();
        try epoll.add(connection.stream.handle, &.{ .events = Epoll.Events.init(.{ .POLLIN = true }), .data = .{ .ptr = @intFromPtr(connection) } });
    } else |err| {
        print("Error on accept: {}\n", .{err});
    }
}

fn handle_connection(alloc: Allocator, event: Epoll.Event, buffer: []u8, epoll: *Epoll) !void {
    const conn: *Connection = @ptrFromInt(event.data.ptr);
    const readed = try conn.stream.read(buffer);
    if (readed == 0) {
        print("Disconnected: {}\n", .{conn.addr});
        try epoll.remove(conn.stream.handle);
        conn.stream.close();
        conn.device.deinit();
        alloc.destroy(conn);
        return;
    }
    print("Packet from: {}\n", .{conn.addr});
    const slice = buffer[0..readed];
    var p_readed: usize = 0;
    print("Slice len: {}\n", .{slice.len});
    if (slice.len < remote_input.Packet.size()) {
        print("Invalid Packet\n", .{});
    }
    while (slice.len >= p_readed + remote_input.Packet.size()) {
        const packet = std.mem.bytesToValue(remote_input.Packet, slice[p_readed..]);
        print("Packet type: {}\n", .{packet.base.tag});
        switch (packet.base.tag) {
            .Press => {
                try conn.device.press(packet.press.key);
            },
            .Release => {
                try conn.device.release(packet.press.key);
            },
            .MoveX => {
                try conn.device.move_x(packet.move_x.x);
            },
            .MoveY => {
                try conn.device.move_y(packet.move_y.y);
            },
        }
        try packet.verify();
        p_readed += remote_input.Packet.size();
    }
}
