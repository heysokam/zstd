//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Tools & Types to describe Distinct Numbers
//___________________________________________________________|
// @deps std
const std = @import("std");

pub const distinct = Distinct;
pub fn Distinct (T :type) type { return enum(T) {
  None = switch (@typeInfo(T)) {
    .int => std.math.maxInt(T),
    else => unreachable }, // FIX: Implement support for other types
  _,
  pub inline fn val (pos :*const @This()) T { return @intFromEnum(pos); }
  pub inline fn from (num :T) @This() { return @enumFromInt(num); }
  pub inline fn none (pos :*const @This()) bool { return pos == .None; }
  pub inline fn hasValue (pos :*const @This()) bool { return !pos.none(); }
};} //:: zstd.Distinct

