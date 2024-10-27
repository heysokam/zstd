//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview Cable connector to all zstd.Core modules
//__________________________________________________________|

//______________________________________
// @section Forward Exports for other modules
//____________________________
pub const log     = @import("./zstd/log.zig");
pub const shell   = @import("./zstd/shell.zig");
pub const T       = @import("./zstd/types.zig");
pub const array   = T.array;
pub const meta    = @import("./zstd/meta.zig");
pub const files   = @import("./zstd/files.zig");
pub const git     = @import("./zstd/git.zig");
pub const markers = @import("./zstd/markers.zig");
pub const CLI     = @import("./zstd/cli.zig");
pub const paths   = @import("./zstd/paths.zig");
pub const mode    = @import("./zstd/modes.zig");
pub const flags   = @import("./zstd/flags.zig");
pub const Flags   = flags.T;

//______________________________________
// @section Type Exports
//____________________________
pub const cstr        = T.cstr;
pub const cstr_List   = T.cstr_List;
pub const zstr        = T.zstr;
pub const seq         = T.seq;
pub const set         = T.set.Set;
pub const UnorderedSet= T.set.Unordered;
pub const str         = T.str;
pub const ByteBuffer  = T.ByteBuffer;
pub const List        = T.List;
pub const DataList    = T.DataList;
pub const Map         = T.Map;
pub const StringTable = T.StringTable;
pub const Name        = T.Name;
pub const Version     = T.Version;
pub const version     = T.version;
pub const Lang        = T.Lang;
pub const System      = T.System;
pub const todo        = markers.todo;

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

//______________________________________
// @section Operating System Aliases
//____________________________
pub const os = struct {
  pub const linux = mode.linux;
  pub const win   = mode.windows;
  pub const macos = mode.macos;
};
pub const linux = mode.linux;
pub const win   = mode.windows;
pub const macos = mode.macos;


//______________________________________
// @section Compile Mode Aliases
//____________________________
pub const debug = mode.debug;
pub const safe  = mode.safe;

