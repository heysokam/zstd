//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview
//!  Toolset to manage Git Tags using CLI tools.
//!  Requires `git` command available in PATH.
//!  Does not depend on libgit.
//________________________________________________|
pub const Tag = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const set  = zstd.set;
const Version = zstd.Version;
// @deps zstd.git
const git = @import("./base.zig");


/// @descr Describes the data for a single Tag
version  :Version,

/// @descr Describes a list of {@link git.Tag}. Tags are considered unique.
pub const List = set(Tag);

pub fn fromVersion (version :Version) Tag { return Tag{.version= version}; }

pub fn eq (A :*const Tag, B :*const Tag) bool {
  return A.version.major == B.version.major
     and A.version.minor == B.version.minor
     and A.version.patch == B.version.patch;
}

pub fn list_contains (list :*const Tag.List, val :*const Tag) bool {
  for (list.items()) | it | { if (it.eq(val)) return true; }
  return false;
}

pub const tag = struct {
  pub const cmd = struct {
    pub const base = "tag";
    pub const push = "push --tags";
  };

  pub fn all (A :std.mem.Allocator) !Tag.List {
    var C = zstd.shell.Cmd.create(A);
    defer C.destroy();
    var result = Tag.List.create(A);

    try C.add(git.cmd);
    try C.add(tag.cmd.base);
    try C.exec();

    var lines = std.mem.splitScalar(u8, C.result.?.stdout.items, '\n');
    while (lines.next()) | line | {
      if (!std.mem.startsWith(u8, line, "v")) continue;
      try result.incl(Tag{.version= try Version.parse(line[1..])});
    }
    return result;
  }

  /// @ref "git push --tags"
  pub fn push (A :std.mem.Allocator) !void {
    var C = zstd.shell.Cmd.create(A);
    defer C.destroy();
    try C.add(git.cmd);
    try C.add(tag.cmd.push);
    try C.exec();
  }
};

