//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
// @deps std
const std = @import("std");
const P   = std.fs.path;
// @deps zstd
const cstring = @import("./type/alias.zig").cstring;
const string  = @import("./type/sequence.zig").string;
const echo = @import("./log.zig").echo;


//______________________________________
// @section Current Folder Tools
//____________________________
inline fn thisDir (A :std.mem.Allocator) cstring {
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
    pub fn change (src :cstring, extension :cstring, A :std.mem.Allocator) !cstring {
      if (file.hasExt(src, extension)) return try A.dupe(u8, src);
      var tmp = try string.create_capacity(src.len*2, A);
      defer tmp.destroy();
      try tmp.add(P.dirname(src) orelse ".");
      try tmp.add(P.sep_str);
      try tmp.add(P.stem(src));
      if (!std.mem.eql(u8, extension, "") and !std.mem.startsWith(u8, extension, ".")) try tmp.add_one('.');
      try tmp.add(extension);
      return try tmp.toOwned();
    }

    /// @descr Returns whether or not {@arg src} ends with {@arg extension}
    pub fn has (src :cstring, extension :cstring) bool {
      if (std.mem.eql(u8, extension, "")) return std.mem.indexOfScalar(u8, src, '.') == null;
      return std.mem.endsWith(u8, src, extension);
    }
  };

  //______________________________________
  // @section Ergonomic Aliases
  //____________________________
  pub const hasExt = file.ext.has;
};

