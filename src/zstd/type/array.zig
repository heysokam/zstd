//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Array management tools
//_______________________________________|
pub const array = @This();
const std  = @import("std");
const zstd = @import("./alias.zig");


pub const cstring = struct {
  pub fn contains (
      arr : zstd.cstr_List,
      val : zstd.cstring,
    ) !bool {
    for (arr) |entry| if (std.mem.eql(u8, entry, val)) return true;
    return false;
  } //:: zstd.array.cstr.contains
}; //:: zstd.array.cstr


pub const zstring = struct {
  pub fn contains (
      arr : zstd.zstr_List,
      val : zstd.zstring,
    ) !bool {
    for (arr) |entry| if (std.mem.eql(u8, entry, val)) return true;
    return false;
  } //:: zstd.array.zstr.contains
}; //:: zstd.array.zstr

