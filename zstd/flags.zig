//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview C Compatible bit-flags
//_______________________________________|
// @deps std
const std = @import("std");


pub fn @"type" (comptime F :type, comptime I :type) type {
  comptime std.debug.assert(@sizeOf(F)    == @sizeOf(I)   );
  // comptime std.debug.assert(@bitSizeOf(F) == @bitSizeOf(I));
  return struct {
    pub fn toInt   (v :F      ) I    { return @bitCast(v); }
    pub fn fromInt (v :I      ) F    { return @bitCast(v); }
    pub fn with    (a :F, b :F) F    { return fromInt(toInt(a) | toInt(b)); }
    pub fn only    (a :F, b :F) F    { return fromInt(toInt(a) & toInt(b)); }
    pub fn without (a :F, b :F) F    { return fromInt(toInt(a) & ~toInt(b)); }
    pub fn hasAll  (a :F, b :F) bool { return (toInt(a) & toInt(b)) == toInt(b); }
    pub fn hasAny  (a :F, b :F) bool { return (toInt(a) & toInt(b)) != 0; }
    pub fn isEmpty (a :F      ) bool { return toInt(a) == 0; }
  };
}

