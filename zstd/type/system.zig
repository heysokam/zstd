//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview
//!  Describes the metadata and tools to manage OS+CPU+ABI Information.
//______________________________________________________________________|
pub const System = @This();
// @deps std
const std      = @import("std");
pub const Os   = std.Target.Os.Tag;
pub const Cpu  = std.Target.Cpu.Arch;
pub const Abi  = std.Target.Abi;
// @deps zstd
const zstd = @import("../type/alias.zig");
const str  = zstd.str;
const cstr = zstd.cstr;

os   :System.Os,
cpu  :System.Cpu,
abi  :System.Abi,

pub const default = struct {
  pub fn abi (cpu :System.Cpu, os :System.Os) System.Abi {
    if (os == .linux) return System.Abi.gnu; // TODO: Figure out how to output musl that is generally compatible
    return System.Abi.default(cpu, std.Target.Os{.tag= os, .version_range= std.Target.Os.VersionRange.default(os, cpu)});
  }
};
pub const parse = struct {
  pub fn abi (S :cstr) System.Abi {
    for (comptime std.enums.values(System.Abi)) |tag| { if (std.mem.eql(u8, S, @tagName(tag))) return tag; }
    return System.host().abi;
  }
  pub fn os (S :cstr) System.Os {
    for (comptime std.enums.values(System.Os)) |tag| { if (std.mem.eql(u8, S, @tagName(tag))) return tag; }
    return System.host().os;
  }
  pub fn cpu (S :cstr) System.Cpu {
    for (comptime std.enums.values(System.Cpu)) |tag| { if (std.mem.eql(u8, S, @tagName(tag))) return tag; }
    return System.host().cpu;
  }
};

//______________________________________
/// @descr Returns the {@link System} that the code is running on.
pub fn host () System {
  const curr = @import("builtin");
  return System{
    .os  = curr.os.tag,
    .cpu = curr.cpu.arch,
    .abi = curr.abi,
  };
}

//______________________________________
/// @descr
///  Returns a list of with the "BigFour" desktop systems/platforms.
///  1. Windows
///  2. Linux
///  3. Mac.x64
///  4. Mac.arm
/// @note
///  ABI will be GNU's glibc for all of them
///  _Zig defaults to static musl on linux. Create a custom System if you need linux+musl_
pub fn desktops () []const System {
  return &.{
    System{.os= Os.linux,   .cpu= Cpu.x86_64,  .abi= Abi.gnu,  },
    System{.os= Os.windows, .cpu= Cpu.x86_64,  .abi= Abi.gnu,  },
    System{.os= Os.macos,   .cpu= Cpu.x86_64,  .abi= Abi.none, },
    // System{.os= Os.macos,   .cpu= Cpu.aarch64, .abi= Abi.none, },  // TODO: Build for arm64
  };
}

pub fn zigTriple (system :*const System, A :std.mem.Allocator) !cstr {
  var result = str.init(A);
  const W = result.writer();
  try W.print("{s}-{s}", .{@tagName(system.cpu), @tagName(system.os)});
  if (system.abi != .none) try W.print("-{s}", .{@tagName(system.abi)}); // Only add the ABI when there is one
  return try result.toOwnedSlice();
}

/// @descr Returns whether or not {@arg A} is the same CPU-OS as {@arg B}
/// @note Ignores ABI from the check. Use {@link eq_strict} for checking all fields.
pub fn eq (A :*const System, B :System) bool { return A.cpu == B.cpu and A.os == B.os; }
/// @descr Returns whether or not {@arg A} is the same CPU-OS-ABI as {@arg B}
pub fn eq_strict (A :*const System, B :System) bool { return A.eq(B) and A.abi == B.abi; }
/// @descr Returns true if the given {@arg system} is not the same as the current host running the code.
pub fn cross (system :*const System) bool { return !system.eq(System.host()); }

