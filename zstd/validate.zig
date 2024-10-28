//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
// @fileoverview Validation & Assertions
//_______________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const cstr = @import("./types.zig").cstr;

pub const ensure = validate.always;
pub const assert = validate.debug;

pub const validate = struct {
  const builtin = @import("builtin");
  pub fn always (cond :bool, msg :cstr) void {
    if (!cond) std.debug.panic(msg++"\n", .{});
  } //:: zstd.validate.always

  pub fn debug (cond :bool, msg :cstr) void {
    if (!std.debug.runtime_safety) return;
    if (!cond) std.debug.panic(msg++"\n", .{});
  } //:: zstd.validate.debug
}; //:: zstd.validate

