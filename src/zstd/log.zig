//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Core Logger functionality
//___________________________________________|
// @deps std
const std = @import("std");

//______________________________________
// @section Aliased exports from std
//____________________________
pub const dbg  = @import("std").debug.print;
pub const fail = @import("std").debug.panic;


//______________________________________
/// @descr Outputs the {@arg msg} to CLI with an added \n at the end.
pub fn prnt (comptime fmt :[]const u8, msg :anytype) void {
  // stdout for the output of the app, not for debugging messages.
  var stdout_buffer :[1024]u8= undefined;
  var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
  const stdout = &stdout_writer.interface;
  stdout.print(fmt++"\n", msg) catch unreachable;
  stdout.flush() catch unreachable;
}
//______________________________________
/// @descr Outputs the {@arg msg} to CLI with an added \n at the end.
pub fn echo (msg :[]const u8) void { prnt("{s}", .{msg}); }

