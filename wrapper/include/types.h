#include "jlcxx/jlcxx.hpp"
#include "legion.h"
#include "legate.h"
#include "legion/legion_config.h"


//Wraps the enums which define how legate
// and cupynumeric types map to legion types
void wrap_type_enums(jlcxx::Module&);

// Wraps the legate functions which return the
// specified legate::Type. (e.g. legate::int8())
void wrap_type_getters(jlcxx::Module&);

// Wraps the privilege modes used in
// FieldAccessor (AcessorRO, AccessorWO)
void wrap_privilege_modes(jlcxx::Module&);