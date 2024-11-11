//:___________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
//! @fileoverview
//!  Toolset to manage Git Diffs using CLI tools.
//!  Requires `git` command available in PATH.
//!  Does not depend on libgit.
//________________________________________________|
const diff = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
const git  = @import("./base.zig");


const cmd = struct {
  const base = "diff";
};

pub const file = struct {
  /// @note The caller must free the result using the given Allocator
  /// @ref "git diff HASH~N HASH THEFILE"
  pub fn byHashN (F :cstr, hash :cstr, N :usize, A :std.mem.Allocator) !cstr {
    var C = zstd.shell.Cmd.create(A);
    defer C.destroy();
    try C.add(git.cmd);
    try C.add(diff.cmd.base);
    try C.add(try std.fmt.allocPrint(A, "{s}~{d}", .{hash, N}));
    try C.add(hash);
    try C.add(F);
    try C.exec();

    return A.dupe(u8, C.result.?.stdout.items);
  }
  /// @note The caller must free the result using the given Allocator
  pub fn byHash (F :cstr, hash :cstr, A :std.mem.Allocator) !cstr { return diff.file.byHashN(F, hash, 1, A); }
};

