#include "cupynumeric/cupynumeric/operators.h"
#include "cupynumeric/cupynumeric/ndarray.h"
#include "legate/legate/type/type_info.h"
#include "legate/legate/data/logical_store.h"
#include "legate/legate/data/shape.h"
#include "legate/legate/runtime/runtime.h"

#include <vector>

// Test the C++ workflow loaded from the legate/cupynumeric libraries

// General Idea:
    // 1. Construct Runtime
    // 2. Use Runtime to create Logical Store
    // 3. Use Logical Store to create NDArray
    // 4. Use NDArray to call operations (e.g., dot)

void test_workflow(){
    Runtime r();
    std::vector<uint64_t> dims1 = {4,2};
    std::vector<uint64_t> dims2 = {2,4};

    Shape s1(dims1);
    Shape s2(dims2);

    PrimitiveType pt(3); // INT32
    LogicalStore ls1 = r.create_store(s1, pt);
    LogicalStore ls2 = r.create_store(s2, pt);

    NDArray arr1(ls1);
    NDArray arr2(ls2);

    //& are you supposed to pass to BinaryOp somehow?
    //& but that also returns void
    //& python lib puts the result in lhs
    dot(arr1, arr2); //& this returns nothing???


}
