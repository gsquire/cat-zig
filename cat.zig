const std = @import("std");
const fs = std.fs;

fn readFile(fname: []const u8) !void {
    const stdout = std.io.getStdOut().outStream();

    var f = try fs.cwd().openFile(fname, fs.File.OpenFlags{ .read = true });
    defer f.close();

    var buf: [std.mem.page_size]u8 = undefined;
    var bytes_read = try f.read(buf[0..]);
    while (bytes_read > 0) {
        try stdout.print("{}", .{buf[0..bytes_read]});
        bytes_read = try f.read(buf[0..]);
    }
}

pub fn main() void {
    var args = std.process.args();

    // Advance the iterator since we want to ignore the binary name.
    var bin_name = args.nextPosix();

    var fname = args.nextPosix();
    if (fname == null) {
        std.debug.warn("expected at least one file name as an argument\n", .{});
        std.os.exit(1);
    }

    if (readFile(fname.?)) |_| {} else |err| {
        std.debug.warn("error reading file: {}\n", .{err});
    }

    // We may have been passed more than one file so try and read them here.
    while (args.nextPosix()) |a| {
        if (readFile(a)) |_| {} else |err| {
            std.debug.warn("error reading file: {}\n", .{err});
        }
    }
}
