#include "legate.h"
#include "cupynumeric.h"
#include <vector>
#include <iostream>

// This is the workflow I would like to 
// re-create in Julia

cupynumeric::NDArray test_workflow(){
    N = 25
    auto arr1 = cupynumeric::full({N}, 2.0);
    auto arr2 = cupynumeric::full({N}, 2.0);

    return cupynumeric::dot(arr1, arr2)
}

int main(int argc, char** argv){
    auto result = legate::start(argc, argv);
    assert(result == 0);

    cupynumeric::initialize(argc, argv);

    auto res = test_workflow();

    std::cout << res[0] << std::endl;

    return legate::finish();
}