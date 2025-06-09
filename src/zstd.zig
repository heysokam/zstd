//:____________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:____________________________________________________________________
//! @fileoverview Cable connector to all zstd.Core modules
//__________________________________________________________|
pub const zstd = @This();

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
pub const Flags   = flags.type;

//______________________________________
// @section Return code for the Main Entry Point of apps.
//____________________________
pub const result  = @import("./zstd/result.zig");
pub const Result  = result.type;
pub const ok      = result.ok;
pub const tst     = result.tst;
pub const warn    = result.warn;
pub const err     = result.err;
pub const fatal   = result.fatal;


//______________________________________
// @section Type Exports
//____________________________
pub const cstr        = T.cstr;
pub const cstr_List   = T.cstr_List;
pub const zstr        = T.zstr;
pub const zstr_List   = T.zstr_List;
pub const seq         = T.seq;
pub const set         = T.set.Set;
pub const UnorderedSet= T.set.Unordered;
pub const string      = T.string;
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
pub const Distinct    = T.Distinct;
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

//______________________________________
// @section Validation & Assertions
//____________________________
pub const validate = @import("./zstd/validate.zig").validate;
pub const ensure   = validate.always;
pub const assert   = validate.debug;
