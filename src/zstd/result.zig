//:___________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
//! @fileoverview Return code for the Main Entry Point of apps.
//______________________________________________________________|
pub const result = @This();

pub const @"type" = enum(result.Value) {
  pub const Value = result.Value;
  ok     = 0,
  tst    = 42,
  warn   = 100,
  err    = 101,
  fatal  = 102,
  _,
  pub inline fn val (R :@This()) @This().Value { return @intFromEnum(R); }
  pub inline fn Ok () @This().Value { return @intFromEnum(@This().ok); }
  pub inline fn Test () @This().Value { return @intFromEnum(@This().tst); }
  pub inline fn Warn () @This().Value { return @intFromEnum(@This().warn); }
  pub inline fn Err () @This().Value { return @intFromEnum(@This().err); }
  pub inline fn Fatal () @This().Value { return @intFromEnum(@This().fatal); }
}; //:: zstd.result.type

const Value  = u8;
const Result = result.type;
pub inline fn ok    () result.Value { return Result.Ok(); }
pub inline fn tst   () result.Value { return Result.Test(); }
pub inline fn warn  () result.Value { return Result.Warn(); }
pub inline fn err   () result.Value { return Result.Err(); }
pub inline fn fatal () result.Value { return Result.Fatal(); }

