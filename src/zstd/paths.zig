//:___________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
const P   = std.fs.path;
// @deps zstd
const zstd = @import("./type/alias.zig");
const cstr = zstd.cstr;
const str  = zstd.str;
const echo = @import("./log.zig").echo;


//______________________________________
// @section Current Folder Tools
//____________________________
inline fn thisDir (A :std.mem.Allocator) cstr {
  const abspath = comptime std.fs.path.dirname(@src().file) orelse ".";
  return std.fs.path.relative(A, "./", abspath) catch unreachable;
}


//______________________________________
// @section File Management
//____________________________
pub const file = struct {
  //______________________________________
  // @section File Extension Management
  //____________________________
  pub const ext = struct {
    /// @descr Returns a new {@link cstr} created by changing the file extension of {@arg src} to {@arg extension}
    /// @warning The caller must free the result.
    pub fn change (src :cstr, extension :cstr, A :std.mem.Allocator) !cstr {
      if (file.hasExt(src, extension)) return try A.dupe(u8, src);
      var tmp = try str.initCapacity(A, src.len*2);
      defer tmp.deinit();
      try tmp.appendSlice(P.dirname(src) orelse ".");
      try tmp.appendSlice(P.sep_str);
      try tmp.appendSlice(P.stem(src));
      if (!std.mem.eql(u8, extension, "") and !std.mem.startsWith(u8, extension, ".")) try tmp.append('.');
      try tmp.appendSlice(extension);
      return try tmp.toOwnedSlice();
    }

    /// @descr Returns whether or not {@arg src} ends with {@arg extension}
    pub fn has (src :cstr, extension :cstr) bool {
      if (std.mem.eql(u8, extension, "")) return std.mem.indexOfScalar(u8, src, '.') == null;
      return std.mem.endsWith(u8, src, extension);
    }
  };

  //______________________________________
  // @section Ergonomic Aliases
  //____________________________
  pub const hasExt = file.ext.has;
};

