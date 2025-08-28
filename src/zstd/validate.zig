//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
// @fileoverview Validation & Assertions
//_______________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const cstring = @import("./types.zig").cstring;

pub const ensure = validate.always;
pub const assert = validate.debug;

pub const validate = struct {
  pub fn always (cond :bool, msg :cstring) void {
    if (!cond) std.debug.panic("{s}\n", .{msg});
  } //:: zstd.validate.always

  pub fn debug (cond :bool, msg :cstring) void {
    if (!std.debug.runtime_safety) return;
    if (!cond) std.debug.panic("{s}\n", .{msg});
  } //:: zstd.validate.debug
}; //:: zstd.validate

