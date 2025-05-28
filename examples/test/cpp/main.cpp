#include <vector>
#include <random>
#include <ctime>

#include "jlcxx/jlcxx.hpp"

class GetVector {
    private:
        std::vector<double> values;
        
    public:
        // Constructor that takes size N and generates random values
        GetVector(size_t N) {
            // Set up random number generator
            // std::mt19937 rng(static_cast<unsigned int>(std::time(nullptr)));
            // std::uniform_real_distribution<double> dist(0.0, 1.0);
            
            // Resize vector and fill with random values
            values.resize(N);
            // for (size_t i = 0; i < N; ++i) {
                // values[i] = dist(rng);
            // }
        }
        
        void set(size_t index, double val) {
            values[index] = val;
        }
        
};

JLCXX_MODULE define_julia_module(jlcxx::Module& mod) {

    mod.add_type<GetVector>("CppVector")
        .constructor<size_t>()
        .method("set", &GetVector::set);

}