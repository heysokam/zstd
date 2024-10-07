//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const seq = @import("./alias.zig").seq;

pub fn DataList (T :type) type {
  const Entries = seq(T);
  return struct {
    entries  :?Entries=  null,
    pub fn create (A :std.mem.Allocator) @This() { return @This(){.entries= Entries.init(A)}; }
    pub fn add (L :*@This(), val :T) !void { try L.entries.?.append(val); }
  };
}

