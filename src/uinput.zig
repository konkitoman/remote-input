const std = @import("std");
const c = @cImport({
    @cInclude("linux/uinput.h");
});

const Key = @import("remote-input.zig").Key;

pub const DeviceSetup = struct {
    name: [80:0]u8,
    keyboard: bool,
    keys: []const Key,
};

fn ioctl2(fd: c_int, req: c_int) !void {
    const err = std.c.ioctl(fd, req);
    if (err != 0) return error.IoCtlError;
}

fn ioctl3(fd: c_int, req: c_int, value: anytype) !void {
    const err = std.c.ioctl(fd, req, value);
    if (err != 0) return error.IoCtlError;
}

pub const Device = struct {
    uinput: c_int,
    setup: DeviceSetup,

    pub fn init(setup: DeviceSetup) !Device {
        const uinput = try std.posix.open("/dev/uinput", .{ .NONBLOCK = true, .ACCMODE = .WRONLY }, 1);

        if (setup.keyboard) {
            try ioctl3(uinput, c.UI_SET_EVBIT, c.EV_KEY);
            for (setup.keys) |key| {
                try ioctl3(uinput, c.UI_SET_KEYBIT, @intFromEnum(key));
            }
        }

        try ioctl3(uinput, c.UI_SET_EVBIT, c.EV_REL);
        try ioctl3(uinput, c.UI_SET_RELBIT, c.REL_X);
        try ioctl3(uinput, c.UI_SET_RELBIT, c.REL_Y);

        // syncronization
        try ioctl3(uinput, c.UI_SET_EVBIT, c.EV_SYN);

        try ioctl3(uinput, c.UI_DEV_SETUP, c.struct_uinput_setup{ .name = setup.name, .id = .{ .bustype = c.BUS_USB, .vendor = 0x2121, .product = 0x1, .version = 0x1 }, .ff_effects_max = c.FF_MAX_EFFECTS });
        try ioctl2(uinput, c.UI_DEV_CREATE);

        return .{
            .uinput = uinput,
            .setup = setup,
        };
    }

    pub fn emit(self: *Device, ty: u16, code: u16, value: c_int) !void {
        const event = c.struct_input_event{ .time = .{ .tv_sec = 0, .tv_usec = 0 }, .type = ty, .code = code, .value = value };
        _ = try std.posix.write(self.uinput, std.mem.asBytes(&event));
    }

    pub fn move_x(self: *Device, x: i32) !void {
        try self.emit(c.EV_REL, c.REL_X, x);
        try self.emit(c.EV_SYN, c.SYN_REPORT, 0);
    }

    pub fn move_y(self: *Device, y: i32) !void {
        try self.emit(c.EV_REL, c.REL_Y, y);
        try self.emit(c.EV_SYN, c.SYN_REPORT, 0);
    }

    pub fn press(self: *Device, key: Key) !void {
        if (!std.mem.containsAtLeast(Key, self.setup.keys, 1, &.{key})) {
            std.debug.print("{}\n", .{key});
            return error.KeyWasNotRegisteredInSetup;
        }
        try self.emit(c.EV_KEY, @intFromEnum(key), 1);
        try self.emit(c.EV_SYN, c.SYN_REPORT, 0);
    }

    pub fn release(self: *Device, key: Key) !void {
        if (!std.mem.containsAtLeast(Key, self.setup.keys, 1, &.{key})) {
            std.debug.print("{}\n", .{key});
            return error.KeyWasNotRegisteredInSetup;
        }
        try self.emit(c.EV_KEY, @intFromEnum(key), 0);
        try self.emit(c.EV_SYN, c.SYN_REPORT, 0);
    }

    pub fn deinit(self: *Device) void {
        _ = c.ioctl(self.uinput, c.UI_DEV_DESTROY);
        std.posix.close(self.uinput);
    }
};
