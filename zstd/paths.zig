//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
const std = @import("std");

inline fn thisDir(allocator: std.mem.Allocator) []const u8 {
  const abspath = comptime std.fs.path.dirname(@src().file) orelse ".";
  return std.fs.path.relative(allocator, "./", abspath) catch unreachable;
}

