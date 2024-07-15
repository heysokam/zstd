//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview
//!  Toolset to manage Git Commmits using CLI tools.
//!  Requires `git` command available in PATH.
//!  Does not depend on libgit.
//___________________________________________________|
const Commit = @This();
// @deps std
const std  = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
const seq  = zstd.seq;
// @deps zstd.git
const diff = @import("./diff.zig");


/// @descr Describes the data for a single Commit
A     :std.mem.Allocator,
hash  :cstr,
msg   :cstr,
body  :cstr,

/// @descr Describes the data for a list of Commits
pub const List = seq(Commit);

pub fn create (A :std.mem.Allocator, args:struct {
  hash : cstr,
  msg  : cstr,
  body : cstr,
}) !Commit {
  return Commit{.A= A,
    .msg  = try A.dupe(u8, args.msg),
    .hash = try A.dupe(u8, args.hash),
    .body = try A.dupe(u8, args.body),
  };
}

pub fn destroy (C :*const Commit) void { C.A.free(C.hash); C.A.free(C.msg); C.A.free(C.body); }

/// @descr Returns true if the {@arg C} commit modifies the {@arg file} matching the {@arg patter} at the start of any line of its diff
pub fn modified (C :*Commit, file :cstr, pattern :cstr) !bool {
  // Get the diff of the file for this commit
  const fileDiff = try diff.file.byHash(file, C.hash, C.A);
  var lines  = std.mem.splitScalar(u8, fileDiff, '\n');
  while (lines.next()) | line | {
    if (line.len == 0                     ) continue; // Skip empty lines
    if (!std.mem.startsWith(u8, line, "+")) continue; // Skip lines that don't add changes
    if (line.len == 1                     ) continue; // Skip new newlines (start with + and contain nothing else)
    if (!std.mem.startsWith(u8, line[1..line.len], pattern)) continue;
    // If we reached this far, the commit modified the file
    return true;
  }
  return false;
}

