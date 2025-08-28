//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
//! @fileoverview Forward Export all other type modules
//______________________________________________________|


//______________________________________
// @section Forward Aliases
//____________________________
pub const alias        = @import("./type/alias.zig");
pub const todo         = alias.todo;
pub const zstring      = alias.zstring;
pub const zstr         = alias.zstr;
pub const zstring_List = alias.zstring_List;
pub const zstr_List    = alias.zstr_List;
pub const cstring      = alias.cstring;
pub const cstr         = alias.cstr;
pub const mstring      = alias.mstring;
pub const mstr         = alias.mstr;
pub const cstring_List = alias.cstring_List;
pub const cstr_List    = alias.cstr_List;
pub const List         = std.MultiArrayList;
pub const Map          = alias.Map;
pub const StringTable  = alias.StringTable;


//______________________________________
// @section Forward Sequence
//____________________________
pub const sequence = @import("./type/sequence.zig");
pub const string     = sequence.string;
pub const ByteBuffer = sequence.ByteBuffer;
pub const seq        = sequence.seq;
pub const Str        = sequence.Str;


//______________________________________
// @section Forward Set
//____________________________
pub const set = @import("./type/set.zig");
pub const Unordered = set.Unordered;
pub const Ordered   = set. Ordered;


//______________________________________
// @section Forward Name
//____________________________
pub const Name = @import("./type/name.zig").Name;


//______________________________________
// @section Forward Version
//____________________________
pub const vers = @import("./type/version.zig");
pub const Version  = vers.Version;
pub const version  = vers.version;
pub const version2 = vers.version2;


//______________________________________
// @section Forward Lang
//____________________________
pub const Lang = @import("./type/lang.zig").Lang;


//______________________________________
// @section Forward System
//____________________________
pub const System = @import("./type/system.zig");


//______________________________________
// @section Forward List
//____________________________
pub const datalist = @import("./type/list.zig");
pub const DataList  = datalist.DataList;
pub const DataList2 = datalist.DataList2;


//______________________________________
// @section Forward Array
//____________________________
pub const array = @import("./type/array.zig");


//______________________________________
// @section Forward Distinct
//____________________________
const distinct_ns = @import("./type/distinct.zig");
pub const distinct = distinct_ns.distinct;
pub const Distinct = distinct_ns.Distinct;

