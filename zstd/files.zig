//:_____________________________________________________
//  confy  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:_____________________________________________________
//! @fileoverview Ergonomics and Tools to deal with Files
//________________________________________________________|
// @deps std
const std  = @import("std");
// @deps zstd
const zstd = @import("./types.zig");
const cstr = zstd.cstr;
const cstr_List = zstd.cstr_List;


//______________________________________
// @section File Globbing
//____________________________
/// @descr Returns the list of file paths contained in {@arg dir} that end with extension {@arg ext}
/// @warning The returned list's memory is owned by the caller.
pub fn glob (dir :cstr, ext :cstr, A :std.mem.Allocator) !cstr_List {
  var paths = std.ArrayList([]const u8).init(A);
  var D = try std.fs.cwd().openDir(dir, .{.iterate=true});
  defer D.close();
  var it = D.iterate();
  while (try it.next()) |entry| {
    if (std.mem.endsWith(u8, entry.name, ext)) {
      const file = try std.fs.path.join(A, &.{ dir, entry.name });
      try paths.append(file);
    }
  }
  return try paths.toOwnedSlice();
}

