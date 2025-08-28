//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview
//!  Toolset to manage Git Repositories using CLI tools.
//!  Requires `git` command available in PATH.
//!  Does not depend on libgit.
//______________________________________________________|
pub const Repo = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;


host  :cstr,
owner :cstr,
name  :cstr,


/// @note The caller must free the resulting string
pub fn url (R :*const Repo, A :std.mem.Allocator) !cstr {
  return try std.fmt.allocPrint(A, "{s}/{s}/{s}", .{R.host, R.owner, R.name});
}

