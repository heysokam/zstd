//:_______________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0 :
//:_______________________________________________________
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
  //____________________________________
  /// @descr Combines all fields of all enums listed in {@arg list} into a single Enum type.
  /// @important
  ///  !! The generated type wont' be           `meta.test.4321.T`
  ///  !! It will be its generating expresion   `meta.enums.join(&.{T1,T2,T3});`
  pub fn join (list :[]const type) type {
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
        const name =  E_fields[id].name;
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
  /// @descr
  ///  Returns {@arg val} converted to the target type {@arg To}
  ///  @note {@arg val} must be contained in {@arg To}
  pub fn from (val :anytype, To :type) To {
    const info = @typeInfo(@TypeOf(val)).Enum;
    const id   = @intFromEnum(val);
    inline for (info.fields) | field | {
      if (field.value == id) return @field(To, field.name);
    }
    unreachable;
  }

  // @todo
  const eval_branch_quota_cushion = 5;
  fn Enum_toPackedStruct(comptime E: type, comptime Data: type, comptime field_default: ?Data) type {
      @setEvalBranchQuota(@typeInfo(E).Enum.fields.len + eval_branch_quota_cushion);
      var struct_fields: [@typeInfo(E).Enum.fields.len]std.builtin.Type.StructField = undefined;
      for (&struct_fields, @typeInfo(E).Enum.fields) |*struct_field, enum_field| {
          struct_field.* = .{
              .name = enum_field.name ++ "",
              .type = Data,
              .default_value = if (field_default) |d| @as(?*const anyopaque, @ptrCast(&d)) else null,
              .is_comptime = false,
              .alignment = if (@sizeOf(Data) > 0) @alignOf(Data) else 0,
          };
      }
      return @Type(.{ .Struct = .{
          .layout = .@"packed",
          .fields = &struct_fields,
          .decls = &.{},
          .is_tuple = false,
      } });
  }
  fn PackedSet (comptime E :type, comptime T :type) type { return Enum_toPackedStruct(E, T, false); }
};


test "4321" {
  const T1 = enum { one1, two1, thr1 };
  const T2 = enum { one2, two2, thr2 };
  const T  = meta.enums.join(&.{T1,T2});
  const t1   = T1.one1;
  const t1_1 = T.T1_one1;
  std.debug.print("................\n", .{});
  std.debug.print("T1   : {any}\n", .{T1});
  std.debug.print("T2   : {any}\n", .{T2});
  std.debug.print("T    : {s}\n", .{@typeName(T) });
  std.debug.print("t1   : {any}\n", .{t1});
  std.debug.print("t1_1 : {any}\n", .{t1_1});
}

