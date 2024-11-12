const builtin = @import("builtin");
const std = @import("std");

pub const Events = std.EnumSet(enum(u32) {
    POLLIN = 0x001,
    POLLPRI = 0x002,
    POLLOUT = 0x004,
    POLLRDNORM = 0x040,
    POLLRDBAND = 0x080,
    POLLWRNORM = 0x100,
    POLLWRBAND = 0x200,
    POLLMSG = 0x400,
    POLLERR = 0x008,
    POLLHUP = 0x010,
    POLLRDHUP = 0x2000,
    POLLEXCLUSIVE = 1 << 28,
    POLLWAKEUP = 1 << 29,
    POLLONESHOT = 1 << 30,
    POLLET = 1 << 31,
});

pub const Event = struct {
    events: Events align(4),
    data: std.os.linux.epoll_data align(switch (builtin.cpu.arch) {
        .x86_64 => 4,
        else => @alignOf(std.os.linux.epoll_data),
    }),
};

epfd: c_int,

const Self = @This();

pub fn init(flags: u32) !Self {
    const epfd = try std.posix.epoll_create1(flags);

    return .{
        .epfd = epfd,
    };
}

pub fn deinit(self: *Self) void {
    std.posix.close(self.epfd);
}

pub fn add(self: *Self, fd: c_int, event: ?*const Event) !void {
    try std.posix.epoll_ctl(self.epfd, 1, fd, @ptrCast(@constCast(event)));
}

pub fn remove(self: *Self, fd: c_int) !void {
    try std.posix.epoll_ctl(self.epfd, 2, fd, null);
}

pub fn modify(self: *Self, fd: c_int, event: ?*const Event) !void {
    try std.posix.epoll_ctl(self.epfd, 3, fd, @ptrCast(@constCast(event)));
}

pub fn wait(self: *Self, events: []Event, timeout: i32) !usize {
    return std.posix.epoll_wait(self.epfd, @ptrCast(events), timeout);
}
