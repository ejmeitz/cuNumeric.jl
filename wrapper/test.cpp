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

#include "legate.h"
#include "cupynumeric.h"
#include <vector>
#include <iostream>

// This is the workflow I would like to 
// re-create in Julia

cupynumeric::NDArray test_workflow(){
    size_t N = 25;

    legate::LogicalStore store1;
    legate::LogicalStore store2; 
    
    auto arr1 = cupynumeric::NDArray(store1::fill(2));
    auto arr2 = cupynumeric::NDArray(store2::fill(2));

    return cupynumeric::dot(arr1, arr2);
}

int main(int argc, char** argv){
    auto result = legate::start(argc, argv);
    assert(result == 0);

    cupynumeric::initialize(argc, argv);

    auto res = test_workflow();

    std::cout << res << std::endl;

    return legate::finish();
}
