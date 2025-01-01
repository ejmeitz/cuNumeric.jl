#include "jlcxx/jlcxx.hpp"
#include "legion.h"
#include "legate.h"

//Wraps the enums which define how legate
// and cupynumeric types map to legion types
void wrap_type_enums(jlcxx::Module& mod);

// Wraps the legate functions which return the
// specified legate::Type. (e.g. legate::int8())
void wrap_type_getters(jlcxx::Module& mod);