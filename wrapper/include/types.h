/* Copyright 2025 Northwestern University,
 *                   Carnegie Mellon University University
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Author(s): David Krasowska <krasow@u.northwestern.edu>
 *            Ethan Meitz <emeitz@andrew.cmu.edu>
 */

#pragma once

#include "jlcxx/jlcxx.hpp"


//Wraps the enums which define how legate
// and cupynumeric types map to legion types
void wrap_type_enums(jlcxx::Module&);

// Wraps the legate functions which return the
// specified legate::Type. (e.g. legate::int8())
void wrap_type_getters(jlcxx::Module&);

// Wraps the privilege modes used in
// FieldAccessor (AcessorRO, AccessorWO)
void wrap_privilege_modes(jlcxx::Module&);

// Unary op codes
void wrap_unary_ops(jlcxx::Module&);

//Unary reduction op codes
void wrap_unary_reds(jlcxx::Module&);

//Binary op codes
void wrap_binary_ops(jlcxx::Module&);