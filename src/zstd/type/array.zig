//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Array management tools
//_______________________________________|
const std  = @import("std");
const zstd = @import("./alias.zig");

pub const array = struct {
  pub const cstr = struct {
    pub fn contains (
        arr : zstd.cstr_List,
        val : zstd.cstr,
      ) !bool {
      for (arr) |entry| if (std.mem.eql(u8, entry, val)) return true;
      return false;
    } //:: zstd.array.cstr.contains
  }; //:: zstd.array.cstr

  pub const zstr = struct {
    pub fn contains (
        arr : zstd.zstr_List,
        val : zstd.zstr,
      ) !bool {
      for (arr) |entry| if (std.mem.eql(u8, entry, val)) return true;
      return false;
    } //:: zstd.array.zstr.contains
  }; //:: zstd.array.zstr
}; //:: zstd.array
