//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview
//!  Toolset to manage Git repositories using CLI tools.
//!  Requires `git` command available in PATH.
//!  Does not depend on libgit.
//______________________________________________________|
const git = @This();
// @deps std
const std  = @import("std");
// @deps zstd
const zstd = @import("../zstd.zig");
const cstr = zstd.cstr;
const seq  = zstd.seq;
const set  = zstd.set;
const Version = zstd.Version;
const prnt = zstd.prnt;


pub const Repo   = @import("./git/repo.zig");
pub const Commit = @import("./git/commit.zig");
pub const Tag    = @import("./git/tag.zig");
pub const tag    = Tag.tag;
pub const log    = @import("./git/log.zig");
pub const diff   = @import("./git/diff.zig");
pub const cmd    = @import("./git/base.zig").cmd;

