//:____________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
//:____________________________________________________
//! @fileoverview Tools for Zig's Type system and Meta-Programming
//__________________________________________________________________|
pub const meta = @This();
// @deps std
const std = @import("std");
// @deps zstd
const cstr = @import("./types.zig").cstr;


pub const types = struct {
  //____________________________________
  /// @descr Returns the last part of the typeName for T, without any of its `one.two.Typ` dot prefixes
  pub fn name(T :type) []const u8 {
    const N = @typeName(T); // Name
    const S = if (std.mem.lastIndexOfScalar(u8, N, '.')) |n| n+1 else 0; // Start
    return N[S..]; // Return the name, cut from Start until its last char
  }
};

pub const enums = struct {
  const Separator = struct {
    const char = '_';
    const str  = "_";
  };

  //____________________________________
  /// @descr Returns {@arg name} without its SomeT_ prefix
  pub fn fieldName(name :cstr) cstr {
    const start = if (std.mem.lastIndexOfScalar(u8, name, enums.Separator.char)) |n| n+1 else 0;
    return name[start..name.len];
  }

  //____________________________________
  /// @warning
  ///   !!! Broken in 0.13.0 !!!
  ///   See: https://github.com/ziglang/zig/issues/20504
  ///
  /// @descr
  ///  Combines all fields of all enums listed in {@arg list} into a single Enum type.
  ///  Will return an enum with prefixed fields when {@arg prefix} is not omitted and sent as true
  ///  @note Prefixes are created as `T_`
  pub fn join (list :[]const type, comptime args :struct {
      prefix :bool= true,
    }) type {
    var index :usize= 0;
    // Find the total Length of the enum
    var length :usize= 0;
    for (list) |E| { length += @typeInfo(E).Enum.fields.len; }
    // Find the list of enum fields
    var fields :[length]std.builtin.Type.EnumField= undefined;
    for (list) |E| {
      const E_fields = @typeInfo(E).Enum.fields;
      for (0..E_fields.len) | id | {
        defer index += 1;
        const name = if (args.prefix) (meta.types.name(E) ++ enums.Separator.str ++ E_fields[id].name) else E_fields[id].name;
        fields[index] = .{
          .name  = name,
          .value = index,
        };
      }
    }
    // Return the resulting enum
    return @Type(.{.Enum= .{
      .tag_type      = std.math.IntFittingRange(0, fields.len -| 1),
      .fields        = &fields,
      .decls         = &.{},
      .is_exhaustive = true,
      }
    });
  }

  //____________________________________
  /// @warning
  ///   !!! Broken in 0.13.0 !!!
  ///   See: https://github.com/ziglang/zig/issues/20504
  ///
  /// @descr Combines all fields of {@arg A} and {@arg B} enums into a single Enum type.
  pub fn join2(A :type, B :type) type {
    const A_fields = @typeInfo(A).Enum.fields;
    const B_fields = @typeInfo(B).Enum.fields;
    var new_fields :[A_fields.len + B_fields.len]std.builtin.Type.EnumField= undefined;
    var new_index :usize= 0;

    for (0..A_fields.len) |id| {
      defer new_index += 1;
      new_fields[new_index] = .{
        .name = A_fields[id].name,
        .value = new_index,
      };
    }

    for (0..B_fields.len) |id| {
      defer new_index += 1;
      new_fields[new_index] = .{
        .name = B_fields[id].name,
        .value = new_index,
      };
    }

    return @Type(.{.Enum= .{
      .tag_type = std.math.IntFittingRange(0, new_fields.len -| 1),
      .fields = &new_fields,
      .decls = &.{},
      .is_exhaustive = true,
      }
    });
  }

  /// @descr Action to take when converting an enum field with `zstd.meta.enums.from(val, ToType, .{.prefix= OPTION})`
  ///  - none : Will act as if there were no prefixes
  ///  - add  : Will add a prefix to `val.fieldName` before searching for its field inside the {@arg To} list of fields.
  ///  - rmv  : Will remove a prefix to `val.fieldName` before searching for its field inside the {@arg To} list of fields.
  const ConversionPrefix = enum { none, add, rmv };
  /// @warning
  ///   !!! Broken in 0.13.0 !!!
  ///   See: https://github.com/ziglang/zig/issues/20504
  ///
  /// @descr
  ///  Returns {@arg val} converted to the target type {@arg To}
  ///  The option {@arg args.prefix} (default: none) will dictate whether the SomeT_ prefix will be added, removed or ignored.
  ///  @note {@arg val} must be contained in {@arg To}
  pub fn from (val :anytype, To :type, comptime args :struct {
      prefix :ConversionPrefix= .none,
    }) To {
    const info = @typeInfo(@TypeOf(val)).Enum;
    const id   = @intFromEnum(val);
    inline for (info.fields) | field | {
      const name = switch (args.prefix) {
        .none => comptime field.name,
        .add  => comptime (meta.types.name(To) ++ enums.Separator.str ++ field.name),
        .rmv  => comptime enums.fieldName(field.name),
      };
      if (field.value == id) return @field(To, name);
    }
    unreachable;
  }
};

