//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview Cable connector to all zstd.Core modules
//__________________________________________________________|
// @section Forward Exports for other modules
pub const log   = @import("./zstd/log.zig");
pub const shell = @import("./zstd/shell.zig");
pub const T     = @import("./zstd/types.zig");
pub const meta  = @import("./zstd/meta.zig");
pub const files = @import("./zstd/files.zig");

//______________________________________
// @section Type Exports
//____________________________
pub const cstr       = T.cstr;
pub const Version    = T.Version;
pub const Name       = T.Name;
pub const Seq        = T.Seq;
pub const Str        = T.Str;
pub const ByteBuffer = T.ByteBuffer;
pub const todo       = T.todo;
pub const List       = T.List;
pub const Map        = T.Map;

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

