//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Describes a General Purpose Name.
//__________________________________________________|
// @deps std
const std = @import("std");
// @deps zstd.types
const alias = @import("./alias.zig");
const cstr  = alias.cstr;


//______________________________________
// @section Programming Language Management
//____________________________
pub const Lang = enum {
  None, M, Zig, C, Cpp, Nim, Asm, Unknown,
  /// @descr Returns the language of the {@arg ext} extension. An empty extension will return Unknown lang.
  pub fn fromExt (ext :cstr) Lang {
    const result = if (std.mem.eql(u8, ext, ".cpp")) Lang.Cpp
      else if (std.mem.eql(u8, ext, ".cc"    )) Lang.Cpp
      else if (std.mem.eql(u8, ext, ".c"     )) Lang.C
      else if (std.mem.eql(u8, ext, ".cm"    )) Lang.M
      else if (std.mem.eql(u8, ext, ".zm"    )) Lang.M
      else if (std.mem.eql(u8, ext, ".zig"   )) Lang.Zig
      else if (std.mem.eql(u8, ext, ".nim"   )) Lang.Nim
      else if (std.mem.eql(u8, ext, ".nims"  )) Lang.Nim
      else if (std.mem.eql(u8, ext, ".nimble")) Lang.Nim
      else if (std.mem.eql(u8, ext, ".s"     )) Lang.Asm
      else Lang.Unknown;
    return result;
  }
  /// @descr Returns the language of the {@arg file}, based on its extension. An empty extension will return Unknown lang.
  pub fn fromFile (file :cstr) Lang { return Lang.fromExt(std.fs.path.extension(file)); }
};

