//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview
//!  Toolset to manage Git Logs using CLI tools.
//!  Requires `git` command available in PATH.
//!  Does not depend on libgit.
//________________________________________________|
pub const log = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
const echo = zstd.echo;
// @deps zstd.git
const git    = @import("./base.zig");
const Commit = @import("./commit.zig");


/// @internal
/// @descr Command parts used for git log commands
const cmd = struct {
  const base   = "log";
  const sep = struct {
    const Mid  = " ]][[ ";
    const End  = "]|[";
    const Line = "\""++sep.End++"\n\"";
  };
  const format   = &.{"--format=\"%H"++sep.Mid++"%B\""++sep.End, "--"};
  // const fmt_JSON = "--pretty=format:{%n  \"commit\": \"%H\",%n  \"author\": \"%aN <%aE>\",%n  \"date\": \"%ad\",%n  \"message\": \"%B\"%n},";
};

pub const commits = struct {
  pub fn forFile (file :cstr, A :std.mem.Allocator) !Commit.List {
    var C = zstd.shell.Cmd.create(A);
    defer C.destroy();
    var result = Commit.List.init(A);

    try C.add(git.cmd);
    try C.add(log.cmd.base);
    try C.addList(log.cmd.format);
    if (!std.mem.eql(u8, file, "")) try C.add(file);
    try C.exec();

    // Get commits in inverted order, so that 0 is the first commit
    var lines = std.mem.splitBackwardsSequence(u8, C.result.?.stdout.items, log.cmd.sep.Line);
    while (lines.next()) | line | {
      var parts  = std.mem.splitSequence(u8, line, log.cmd.sep.Mid);
      const H    = parts.next();  // described by %H in the --format="" pattern
      const B    = parts.next();  // described by %B in the --format="" pattern
      var msg_body = std.mem.splitScalar(u8, B.?, '\n');
      const msg  = msg_body.next(); // The message always goes first in %B
      _=msg_body.next();            // Discard empty line separating one from the other
      const body = msg_body.rest();
      try result.append(try Commit.create(A, .{
        .msg  = msg.?,
        .hash = if (std.mem.startsWith(u8, H.?,  "\"")) H.?[1..]            else H.?,  // @hack Strip " from the start of the hash
        .body = if (std.mem.endsWith(u8,   body, "\"")) body[0..body.len-2] else body, // @hack Strip " from the end of the body
        }));
    }
    return result;
  }

  const CommitData = struct {
    commit  :cstr,
    author  :cstr,
    date    :cstr,
    message :cstr,
  };


  pub fn all (A :std.mem.Allocator) !Commit.List {
    return log.commits.forFile("", A);
  }
};

