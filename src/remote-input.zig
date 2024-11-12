const std = @import("std");

pub const Key = enum(u16) { KEY_RESERVED = 0, KEY_ESC = 1, KEY_1 = 2, KEY_2 = 3, KEY_3 = 4, KEY_4 = 5, KEY_5 = 6, KEY_6 = 7, KEY_7 = 8, KEY_8 = 9, KEY_9 = 10, KEY_0 = 11, KEY_MINUS = 12, KEY_EQUAL = 13, KEY_BACKSPACE = 14, KEY_TAB = 15, KEY_Q = 16, KEY_W = 17, KEY_E = 18, KEY_R = 19, KEY_T = 20, KEY_Y = 21, KEY_U = 22, KEY_I = 23, KEY_O = 24, KEY_P = 25, KEY_LEFTBRACE = 26, KEY_RIGHTBRACE = 27, KEY_ENTER = 28, KEY_LEFTCTRL = 29, KEY_A = 30, KEY_S = 31, KEY_D = 32, KEY_F = 33, KEY_G = 34, KEY_H = 35, KEY_J = 36, KEY_K = 37, KEY_L = 38, KEY_SEMICOLON = 39, KEY_APOSTROPHE = 40, KEY_GRAVE = 41, KEY_LEFTSHIFT = 42, KEY_BACKSLASH = 43, KEY_Z = 44, KEY_X = 45, KEY_C = 46, KEY_V = 47, KEY_B = 48, KEY_N = 49, KEY_M = 50, KEY_COMMA = 51, KEY_DOT = 52, KEY_SLASH = 53, KEY_RIGHTSHIFT = 54, KEY_KPASTERISK = 55, KEY_LEFTALT = 56, KEY_SPACE = 57, KEY_CAPSLOCK = 58, KEY_F1 = 59, KEY_F2 = 60, KEY_F3 = 61, KEY_F4 = 62, KEY_F5 = 63, KEY_F6 = 64, KEY_F7 = 65, KEY_F8 = 66, KEY_F9 = 67, KEY_F10 = 68, KEY_NUMLOCK = 69, KEY_SCROLLLOCK = 70, KEY_KP7 = 71, KEY_KP8 = 72, KEY_KP9 = 73, KEY_KPMINUS = 74, KEY_KP4 = 75, KEY_KP5 = 76, KEY_KP6 = 77, KEY_KPPLUS = 78, KEY_KP1 = 79, KEY_KP2 = 80, KEY_KP3 = 81, KEY_KP0 = 82, KEY_KPDOT = 83, KEY_ZENKAKUHANKAKU = 85, KEY_102ND = 86, KEY_F11 = 87, KEY_F12 = 88, KEY_RO = 89, KEY_KATAKANA = 90, KEY_HIRAGANA = 91, KEY_HENKAN = 92, KEY_KATAKANAHIRAGANA = 93, KEY_MUHENKAN = 94, KEY_KPJPCOMMA = 95, KEY_KPENTER = 96, KEY_RIGHTCTRL = 97, KEY_KPSLASH = 98, KEY_SYSRQ = 99, KEY_RIGHTALT = 100, KEY_LINEFEED = 101, KEY_HOME = 102, KEY_UP = 103, KEY_PAGEUP = 104, KEY_LEFT = 105, KEY_RIGHT = 106, KEY_END = 107, KEY_DOWN = 108, KEY_PAGEDOWN = 109, KEY_INSERT = 110, KEY_DELETE = 111, KEY_MACRO = 112, KEY_MUTE = 113, KEY_VOLUMEDOWN = 114, KEY_VOLUMEUP = 115, KEY_POWER = 116, KEY_KPEQUAL = 117, KEY_KPPLUSMINUS = 118, KEY_PAUSE = 119, KEY_SCALE = 120, KEY_KPCOMMA = 121, KEY_HANGEUL = 122, KEY_HANJA = 123, KEY_YEN = 124, KEY_LEFTMETA = 125, KEY_RIGHTMETA = 126, KEY_COMPOSE = 127, KEY_STOP = 128, KEY_AGAIN = 129, KEY_PROPS = 130, KEY_UNDO = 131, KEY_FRONT = 132, KEY_COPY = 133, KEY_OPEN = 134, KEY_PASTE = 135, KEY_FIND = 136, KEY_CUT = 137, KEY_HELP = 138, KEY_MENU = 139, KEY_CALC = 140, KEY_SETUP = 141, KEY_SLEEP = 142, KEY_WAKEUP = 143, KEY_FILE = 144, KEY_SENDFILE = 145, KEY_DELETEFILE = 146, KEY_XFER = 147, KEY_PROG1 = 148, KEY_PROG2 = 149, KEY_WWW = 150, KEY_MSDOS = 151, KEY_SCREENLOCK = 152, KEY_DIRECTION = 153, KEY_CYCLEWINDOWS = 154, KEY_MAIL = 155, KEY_BOOKMARKS = 156, KEY_COMPUTER = 157, KEY_BACK = 158, KEY_FORWARD = 159, KEY_CLOSECD = 160, KEY_EJECTCD = 161, KEY_EJECTCLOSECD = 162, KEY_NEXTSONG = 163, KEY_PLAYPAUSE = 164, KEY_PREVIOUSSONG = 165, KEY_STOPCD = 166, KEY_RECORD = 167, KEY_REWIND = 168, KEY_PHONE = 169, KEY_ISO = 170, KEY_CONFIG = 171, KEY_HOMEPAGE = 172, KEY_REFRESH = 173, KEY_EXIT = 174, KEY_MOVE = 175, KEY_EDIT = 176, KEY_SCROLLUP = 177, KEY_SCROLLDOWN = 178, KEY_KPLEFTPAREN = 179, KEY_KPRIGHTPAREN = 180, KEY_NEW = 181, KEY_REDO = 182, KEY_F13 = 183, KEY_F14 = 184, KEY_F15 = 185, KEY_F16 = 186, KEY_F17 = 187, KEY_F18 = 188, KEY_F19 = 189, KEY_F20 = 190, KEY_F21 = 191, KEY_F22 = 192, KEY_F23 = 193, KEY_F24 = 194, KEY_PLAYCD = 200, KEY_PAUSECD = 201, KEY_PROG3 = 202, KEY_PROG4 = 203, KEY_DASHBOARD = 204, KEY_SUSPEND = 205, KEY_CLOSE = 206, KEY_PLAY = 207, KEY_FASTFORWARD = 208, KEY_BASSBOOST = 209, KEY_PRINT = 210, KEY_HP = 211, KEY_CAMERA = 212, KEY_SOUND = 213, KEY_QUESTION = 214, KEY_EMAIL = 215, KEY_CHAT = 216, KEY_SEARCH = 217, KEY_CONNECT = 218, KEY_FINANCE = 219, KEY_SPORT = 220, KEY_SHOP = 221, KEY_ALTERASE = 222, KEY_CANCEL = 223, KEY_BRIGHTNESSDOWN = 224, KEY_BRIGHTNESSUP = 225, KEY_MEDIA = 226, KEY_SWITCHVIDEOMODE = 227, KEY_KBDILLUMTOGGLE = 228, KEY_KBDILLUMDOWN = 229, KEY_KBDILLUMUP = 230, KEY_SEND = 231, KEY_REPLY = 232, KEY_FORWARDMAIL = 233, KEY_SAVE = 234, KEY_DOCUMENTS = 235, KEY_BATTERY = 236, KEY_BLUETOOTH = 237, KEY_WLAN = 238, KEY_UWB = 239, KEY_UNKNOWN = 240, KEY_VIDEO_NEXT = 241, KEY_VIDEO_PREV = 242, KEY_BRIGHTNESS_CYCLE = 243, KEY_BRIGHTNESS_ZERO = 244, KEY_DISPLAY_OFF = 245, KEY_WIMAX = 246, KEY_RFKILL = 247, KEY_MICMUTE = 248, BTN_LEFT = 0x110, BTN_RIGHT = 0x111, BTN_MIDDLE = 0x112 };

pub const PacketTag = enum(u8) {
    Press,
    Release,
    MoveX,
    MoveY,
};

pub const Packet = packed union {
    base: packed struct { checksum: u64, tag: PacketTag },
    press: packed struct {
        checksum: u64 = 0,
        tag: PacketTag = .Press,
        key: Key,
        _padding: u40 = 0,
    },
    release: packed struct {
        checksum: u64 = 0,
        tag: PacketTag = .Release,
        key: Key,
        _padding: u40 = 0,
    },
    move_x: packed struct {
        checksum: u64 = 0,
        tag: PacketTag = .MoveX,
        x: i32,
        _padding: u24 = 0,
    },
    move_y: packed struct {
        checksum: u64 = 0,
        tag: PacketTag = .MoveY,
        y: i32,
        _padding: u24 = 0,
    },

    const Self = @This();

    pub fn verify(self: Self) !void {
        if (self.base.checksum != self.hash()) {
            return error.ChacksumNotMatching;
        }
    }

    pub fn hash(self: Self) u64 {
        var blake3 = std.crypto.hash.Blake3.init(.{ .key = std.mem.zeroes([32]u8) });
        const bytes = std.mem.asBytes(&self);
        blake3.update(bytes[8..]);

        var buffer: [8]u8 = undefined;
        blake3.final(&buffer);
        return std.mem.readInt(u64, &buffer, .big);
    }

    pub fn update_checksum(self: *Self) void {
        self.base.checksum = self.hash();
    }

    pub fn size() usize {
        return @sizeOf(Packet);
    }
};

pub const RemoteInput = struct {
    stream: std.net.Stream,

    pub fn init(name: []const u8, port: u16) !RemoteInput {
        const n = std.mem.sliceTo(name, 0);
        const address = std.net.Address.parseIp(n, port) catch |err| {
            std.debug.print("RemoteInput_init cannot parse address: {s} Error: {}\n", .{ n, err });
            return err;
        };

        const stream = std.net.tcpConnectToAddress(address) catch |err| {
            std.debug.print("RemoteInput_init Error: {}\n", .{err});
            return err;
        };

        return .{ .stream = stream };
    }

    pub fn send(self: RemoteInput, packet: Packet) !void {
        var pak = packet;
        pak.update_checksum();
        try self.stream.writeAll(&std.mem.toBytes(pak));
    }

    pub fn press(self: RemoteInput, key: Key) !void {
        try self.send(.{ .press = .{ .key = key } });
    }

    pub fn release(self: RemoteInput, key: Key) !void {
        try self.send(.{ .release = .{ .key = key } });
    }

    pub fn move_x(self: RemoteInput, x: i32) !void {
        try self.send(.{ .move_x = .{ .x = x } });
    }

    pub fn move_y(self: RemoteInput, y: i32) !void {
        try self.send(.{ .move_y = .{ .y = y } });
    }

    pub fn deinit(self: RemoteInput) void {
        self.stream.close();
    }

    pub fn ty(self: RemoteInput, text: []const u8) !void {
        for (text) |ch| {
            try self.char(ch);
        }
    }

    pub fn char(self: RemoteInput, ch: u8) !void {
        var shift = std.ascii.isUpper(ch);
        const key = switch (std.ascii.toLower(ch)) {
            '1' => Key.KEY_1,
            '!' => d: {
                shift = true;
                break :d Key.KEY_1;
            },
            '2' => Key.KEY_2,
            '@' => d: {
                shift = true;
                break :d Key.KEY_2;
            },
            '3' => Key.KEY_3,
            '#' => d: {
                shift = true;
                break :d Key.KEY_3;
            },
            '4' => Key.KEY_4,
            '$' => d: {
                shift = true;
                break :d Key.KEY_4;
            },
            '5' => Key.KEY_5,
            '%' => d: {
                shift = true;
                break :d Key.KEY_5;
            },
            '6' => Key.KEY_6,
            '^' => d: {
                shift = true;
                break :d Key.KEY_6;
            },
            '7' => Key.KEY_7,
            '&' => d: {
                shift = true;
                break :d Key.KEY_7;
            },
            '8' => Key.KEY_8,
            '*' => d: {
                shift = true;
                break :d Key.KEY_8;
            },
            '9' => Key.KEY_9,
            '(' => d: {
                shift = true;
                break :d Key.KEY_9;
            },
            '0' => Key.KEY_0,
            ')' => d: {
                shift = true;
                break :d Key.KEY_0;
            },
            'q' => Key.KEY_Q,
            'w' => Key.KEY_W,
            'e' => Key.KEY_E,
            'r' => Key.KEY_R,
            't' => Key.KEY_T,
            'y' => Key.KEY_Y,
            'u' => Key.KEY_U,
            'i' => Key.KEY_I,
            'o' => Key.KEY_O,
            'p' => Key.KEY_P,
            'a' => Key.KEY_A,
            's' => Key.KEY_S,
            'd' => Key.KEY_D,
            'f' => Key.KEY_F,
            'g' => Key.KEY_G,
            'h' => Key.KEY_H,
            'j' => Key.KEY_J,
            'k' => Key.KEY_K,
            'l' => Key.KEY_L,
            'z' => Key.KEY_Z,
            'x' => Key.KEY_X,
            'c' => Key.KEY_C,
            'v' => Key.KEY_V,
            'b' => Key.KEY_B,
            'n' => Key.KEY_N,
            'm' => Key.KEY_M,
            ' ' => Key.KEY_SPACE,
            ',' => Key.KEY_COMMA,
            '<' => b: {
                shift = true;
                break :b Key.KEY_COMMA;
            },
            '.' => Key.KEY_DOT,
            '>' => b: {
                shift = true;
                break :b Key.KEY_DOT;
            },
            '/' => Key.KEY_SLASH,
            '?' => b: {
                shift = true;
                break :b Key.KEY_SLASH;
            },
            ';' => Key.KEY_SEMICOLON,
            ':' => b: {
                shift = true;
                break :b Key.KEY_SEMICOLON;
            },
            '\'' => Key.KEY_APOSTROPHE,
            '"' => b: {
                shift = true;
                break :b Key.KEY_APOSTROPHE;
            },
            '\n' => Key.KEY_ENTER,
            else => {
                std.debug.print("RemoteInput Unknown char: {c}\n", .{ch});
                return error.UnknownChar;
            },
        };

        if (shift) try self.press(.KEY_LEFTSHIFT);

        try self.press(key);
        try self.release(key);

        if (shift) try self.release(.KEY_LEFTSHIFT);
    }
};
