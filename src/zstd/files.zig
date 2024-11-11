//:___________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
//! @fileoverview Ergonomics and Tools to deal with Files
//________________________________________________________|
// @deps std
const std = @import("std");
const Dir = std.fs.Dir;
// @deps zstd
const zstd = @import("./types.zig");
const cstr = zstd.cstr;
const cstr_List = zstd.cstr_List;
const seq  = zstd.seq;


//______________________________________
// @section File Globbing
//____________________________
/// @descr Returns the list of file paths contained in {@arg dir} that end with extension {@arg ext}
/// @warning The returned list's memory is owned by the caller.
pub fn glob (dir :cstr, ext :cstr, A :std.mem.Allocator) !cstr_List {
  var paths = seq(cstr).init(A);
  var D = try std.fs.cwd().openDir(dir, .{.iterate=true});
  defer D.close();
  var it = D.iterateAssumeFirstIteration();
  while (try it.next()) |entry| {
    if (std.mem.endsWith(u8, entry.name, ext)) {
      const file = try std.fs.path.join(A, &.{ dir, entry.name });
      try paths.append(file);
    }
  }
  return try paths.toOwnedSlice();
}


//______________________________________
// @section File Reading
//____________________________
/// @descr Returns the contents of the {@arg src} file as a {@link cstr}
/// @warning The caller must free the result.
pub fn read (src :cstr, A :std.mem.Allocator, args:struct{
    dir         :Dir= std.fs.cwd(),
    maxFileSize :usize= 50*1024,
  }) !cstr {
  return try args.dir.readFileAlloc(A, src, args.maxFileSize);
}


//______________________________________
// @section File Writing
//____________________________
pub fn write (src :cstr, trg :cstr, args:struct{
    dir :Dir= std.fs.cwd(),
  }) !void {
  try args.dir.writeFile(.{.sub_path= trg, .data= src});
}


//______________________________________
// @section File Copying
//____________________________
pub fn copy (src :cstr, trg :cstr, args:struct{
    dir :Dir= std.fs.cwd(),
  }) !void {
  try args.dir.copyFile(src, args.dir, trg, .{});
}

