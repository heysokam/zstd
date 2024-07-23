//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview Cable connector to all zstd.Core modules
//__________________________________________________________|
// @section Forward Exports for other modules
pub const log     = @import("./zstd/log.zig");
pub const shell   = @import("./zstd/shell.zig");
pub const T       = @import("./zstd/types.zig");
pub const meta    = @import("./zstd/meta.zig");
pub const files   = @import("./zstd/files.zig");
pub const git     = @import("./zstd/git.zig");
pub const markers = @import("./zstd/markers.zig");

//______________________________________
// @section Type Exports
//____________________________
pub const cstr       = T.cstr;
pub const cstr_List  = T.cstr_List;
pub const seq        = T.seq;
pub const set        = T.set;
pub const str        = T.str;
pub const ByteBuffer = T.ByteBuffer;
pub const List       = T.List;
pub const Map        = T.Map;
pub const Name       = T.Name;
pub const Version    = T.Version;
pub const version    = T.version;
pub const Lang       = T.Lang;
pub const System     = T.System;
pub const todo       = markers.todo;

//______________________________________
// @section Logger.Core Exports
//____________________________
pub const echo = log.echo;
pub const prnt = log.prnt;
pub const fail = log.fail;


//______________________________________
// @section Shell.Core Exports
//____________________________
pub const sh = shell.zsh;

