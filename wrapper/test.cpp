#include "cupynumeric/cupynumeric/operators.h"
#include "cupynumeric/cupynumeric/ndarray.h"
#include "legate/legate/type/type_info.h"
#include "legate/legate/data/logical_store.h"
#include "legate/legate/data/shape.h"
#include "legate/legate/runtime/runtime.h"

#include <vector>

// This is the workflow I would like to 
// re-create in Julia

void test_workflow(){
    Runtime r();
    std::vector<uint64_t> dims1 = {4,2}; 
    std::vector<uint64_t> dims2 = {2,4};

    Shape s1(dims1);
    Shape s2(dims2);

    PrimitiveType pt(3); // INT32
    LogicalStore ls1 = r.create_store(s1, pt); //how to put data in here?
    LogicalStore ls2 = r.create_store(s2, pt);

    NDArray arr1(ls1);
    NDArray arr2(ls2);

    //& are you supposed to pass to BinaryOp somehow?
    //& but that also returns void
    //& python lib puts the result in lhs
    dot(arr1, arr2); //& this returns nothing???


}

int main(int argc, char** argv){
    test_workflow();
    return 0;
}