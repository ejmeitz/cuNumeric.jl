#include "types.h"

void wrap_type_enums(jlcxx::Module& mod) {

  auto lt = mod.add_type<legate::Type>("LegateType");

  mod.add_bits<legion_type_id_t>("LegionType", jlcxx::julia_type("CppEnum"));
  mod.set_const("LEGION_TYPE_BOOL", 0);
  mod.set_const("LEGION_TYPE_INT8", 1);
  mod.set_const("LEGION_TYPE_INT16", 2);
  mod.set_const("LEGION_TYPE_INT32", 3);
  mod.set_const("LEGION_TYPE_INT64", 4);
  mod.set_const("LEGION_TYPE_UINT8", 5);
  mod.set_const("LEGION_TYPE_UINT16", 6);
  mod.set_const("LEGION_TYPE_UINT32", 7);
  mod.set_const("LEGION_TYPE_UINT64", 8);
  mod.set_const("LEGION_TYPE_FLOAT16", 9);
  mod.set_const("LEGION_TYPE_FLOAT32", 10);
  mod.set_const("LEGION_TYPE_FLOAT64", 11);
  mod.set_const("LEGION_TYPE_COMPLEX32", 12);
  mod.set_const("LEGION_TYPE_COMPLEX64", 13);
  mod.set_const("LEGION_TYPE_COMPLEX128", 14);
  mod.set_const("LEGION_TYPE_TOTAL", 15);

  mod.add_bits<legate::Type::Code>("TypeCode", jlcxx::julia_type("CppEnum"));
  mod.set_const("BOOL", legion_type_id_t::LEGION_TYPE_BOOL);
  mod.set_const("INT8", legion_type_id_t::LEGION_TYPE_INT8);
  mod.set_const("INT16", legion_type_id_t::LEGION_TYPE_INT16);
  mod.set_const("INT32", legion_type_id_t::LEGION_TYPE_INT32);
  mod.set_const("INT64", legion_type_id_t::LEGION_TYPE_INT64);
  mod.set_const("UINT8", legion_type_id_t::LEGION_TYPE_UINT8);
  mod.set_const("UINT16", legion_type_id_t::LEGION_TYPE_UINT16);
  mod.set_const("UINT32", legion_type_id_t::LEGION_TYPE_UINT32);
  mod.set_const("UINT64", legion_type_id_t::LEGION_TYPE_UINT64);
  mod.set_const("FLOAT16", legion_type_id_t::LEGION_TYPE_FLOAT16);
  mod.set_const("FLOAT32", legion_type_id_t::LEGION_TYPE_FLOAT32);
  mod.set_const("FLOAT64", legion_type_id_t::LEGION_TYPE_FLOAT64);
  mod.set_const("COMPLEX64", legion_type_id_t::LEGION_TYPE_COMPLEX64);
  mod.set_const("COMPLEX128", legion_type_id_t::LEGION_TYPE_COMPLEX128);
  mod.set_const("NIL", 15);
  mod.set_const("BINARY", 16);
  mod.set_const("FIXED_ARRAY", 17);
  mod.set_const("STRUCT", 18);
  mod.set_const("STRING", 19);
  mod.set_const("LIST", 20);

  lt.method("code", &legate::Type::code);
}

void wrap_type_getters(jlcxx::Module& mod) {
  mod.method("bool_", &legate::bool_);
  mod.method("int8", &legate::int8);
  mod.method("int16", &legate::int16);
  mod.method("int32", &legate::int32);
  mod.method("int64", &legate::int64);
  mod.method("uint8", &legate::uint8);
  mod.method("uint16", &legate::uint16);
  mod.method("uint32", &legate::uint32);
  mod.method("uint64", &legate::uint64);
  mod.method("float16", &legate::float16);
  mod.method("float32", &legate::float32);
  mod.method("float64", &legate::float64);
  // mod.method("complex32", &legate::complex32);
  mod.method("complex64", &legate::complex64);
  mod.method("complex128", &legate::complex128);
}

void wrap_privilege_modes(jlcxx::Module& mod) {
  // from legion_config.h
  mod.add_bits<legion_privilege_mode_t>("LegionPrivilegeMode",
                                        jlcxx::julia_type("CppEnum"));
  mod.set_const("LEGION_READ_ONLY", legion_privilege_mode_t::LEGION_READ_ONLY);
  mod.set_const("LEGION_WRITE_DISCARD",
                legion_privilege_mode_t::LEGION_WRITE_DISCARD);
}