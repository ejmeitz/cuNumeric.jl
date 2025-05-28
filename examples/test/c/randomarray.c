#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdint.h>

// --- Xoshiro256++ RNG implementation ---
static inline uint64_t rotl(const uint64_t x, int k) {
    return (x << k) | (x >> (64 - k));
}

static uint64_t s[4];

uint64_t xoshiro256pp(void) {
    const uint64_t result = rotl(s[0] + s[3], 23) + s[0];

    const uint64_t t = s[1] << 17;

    s[2] ^= s[0];
    s[3] ^= s[1];
    s[1] ^= s[2];
    s[0] ^= s[3];

    s[2] ^= t;

    s[3] = rotl(s[3], 45);

    return result;
}

// Seed using SplitMix64
uint64_t splitmix64_seed(uint64_t* seed) {
    uint64_t z = (*seed += 0x9E3779B97F4A7C15);
    z = (z ^ (z >> 30)) * 0xBF58476D1CE4E5B9;
    z = (z ^ (z >> 27)) * 0x94D049BB133111EB;
    return z ^ (z >> 31);
}

void seed_xoshiro(uint64_t init_seed) {
    for (int i = 0; i < 4; ++i) {
        s[i] = splitmix64_seed(&init_seed);
    }
}

// Convert to double in [0.0, 1.0)
double random_double() {
    // Shift to get 53 bits for double precision
    return (xoshiro256pp() >> 11) * (1.0 / (1ULL << 53));
}


// Function to allocate an array of random doubles and return the pointer
double* allocate_random_array(int size) {
    // Seed the random number generator (only once)
    // static int seeded = 0;
    // if (!seeded) {
    //     seed_xoshiro((uint64_t)time(NULL));
    //     seeded = 1;
    // }
    
    // Allocate memory for the array
    double* arr = (double*)malloc(size * sizeof(double));
    
    // Fill the array with random values
    // if (arr != NULL) {
    //     for (int i = 0; i < size; i++) {
    //         // Generate random doubles between 0 and 100
    //         arr[i] = (double)random_double(); 
    //     }
    //     //printf("C: Allocated array of %d random numbers at %p\n", size, (void*)arr);
    // } else {
    //     printf("C: Memory allocation failed\n");
    // }
    
    // Return the pointer to Julia
    return arr;
}



void set(double* arr, int index, double val) {
    arr[index] = val;
}