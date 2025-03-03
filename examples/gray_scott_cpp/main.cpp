#include "legate.h"
#include "cupynumeric.h"
#include "realm/cmdline.h"

#include <cassert>

int main(int argc, char** argv)
{
    // Initialize Legate and cupynumeric
    auto result = legate::start(argc, argv);
    assert(result == 0);
    cupynumeric::initialize(argc, argv);

    // Problem parameters
    const double dx  = 1.0;
    const double dt  = dx / 5.0;
    const double c_u = 1.0;
    const double c_v = 0.3;
    const double f   = 0.03;
    const double k   = 0.06;

    // Grid size and number of steps
    const int N       = 1000;
    const int n_steps = 2000;

    // Create and initialize u, v
    auto u = cupynumeric::ones({N, N});
    auto v = cupynumeric::zeros({N, N});


    // Generate a 150x150 array of random float64 values
    auto randU = cupynumeric::random({150, 150});
    auto randV = cupynumeric::random({150, 150});
    // Assign these to the top-left corner
    u[{cupynumeric::slice(0, 150), cupynumeric::slice(0, 150)}].assign(randU);
    v[{cupynumeric::slice(0, 150), cupynumeric::slice(0, 150)}].assign(randV);


    // Create temporary arrays to hold updated values each iteration
    auto u_new = cupynumeric::zeros({N, N});
    auto v_new = cupynumeric::zeros({N, N});

    for (int step = 0; step < n_steps; ++step) {
        // Extract interior slices of u, v
        auto centerU = u[{cupynumeric::slice(1, -1), cupynumeric::slice(1, -1)}];
        auto centerV = v[{cupynumeric::slice(1, -1), cupynumeric::slice(1, -1)}];

        // Reaction terms:
        //   F_u = -u*(v^2) + f*(1-u)
        //   F_v =  u*(v^2) - (f+k)*v
        auto v_sq = centerV * centerV;
        auto F_u  = (-centerU * v_sq) + f * (1.0 - centerU);
        auto F_v  = ( centerU * v_sq) - (f + k) * centerV;

        // 2D Laplacian of u
        auto upU    = u[{cupynumeric::slice(0, -2),    cupynumeric::slice(1, -1)}];
        auto downU  = u[{cupynumeric::slice(2, cupynumeric::open), cupynumeric::slice(1, -1)}];
        auto leftU  = u[{cupynumeric::slice(1, -1), cupynumeric::slice(0, -2)}];
        auto rightU = u[{cupynumeric::slice(1, -1), cupynumeric::slice(2, cupynumeric::open)}];
        auto partialVertU   = upU - (2.0 * centerU) + downU;
        auto partialHorizU  = leftU - (2.0 * centerU) + rightU;
        auto lapU           = partialVertU + partialHorizU;
        lapU                = lapU / (dx * dx);

        // 2D Laplacian of v
        auto upV    = v[{cupynumeric::slice(0, -2),    cupynumeric::slice(1, -1)}];
        auto downV  = v[{cupynumeric::slice(2, cupynumeric::open), cupynumeric::slice(1, -1)}];
        auto leftV  = v[{cupynumeric::slice(1, -1), cupynumeric::slice(0, -2)}];
        auto rightV = v[{cupynumeric::slice(1, -1), cupynumeric::slice(2, cupynumeric::open)}];
        auto partialVertV   = upV - (2.0 * centerV) + downV;
        auto partialHorizV  = leftV - (2.0 * centerV) + rightV;
        auto lapV           = partialVertV + partialHorizV;
        lapV                = lapV / (dx * dx);

        // Forward-Euler update for the interior
        auto interiorU_new = u_new[{cupynumeric::slice(1, -1), cupynumeric::slice(1, -1)}];
        auto interiorV_new = v_new[{cupynumeric::slice(1, -1), cupynumeric::slice(1, -1)}];
        interiorU_new.assign(centerU + dt * (c_u * lapU + F_u));
        interiorV_new.assign(centerV + dt * (c_v * lapV + F_v));

        // Apply periodic boundary conditions: u_new
        u_new[{cupynumeric::slice(), cupynumeric::slice(0, 1)}].assign(
            u[{cupynumeric::slice(), cupynumeric::slice(-2, -1)}]);
        u_new[{cupynumeric::slice(), cupynumeric::slice(-1, cupynumeric::open)}].assign(
            u[{cupynumeric::slice(), cupynumeric::slice(1, 2)}]);
        u_new[{cupynumeric::slice(0, 1), cupynumeric::slice()}].assign(
            u[{cupynumeric::slice(-2, -1), cupynumeric::slice()}]);
        u_new[{cupynumeric::slice(-1, cupynumeric::open), cupynumeric::slice()}].assign(
            u[{cupynumeric::slice(1, 2), cupynumeric::slice()}]);

        // Apply periodic boundary conditions: v_new
        v_new[{cupynumeric::slice(), cupynumeric::slice(0, 1)}].assign(
            v[{cupynumeric::slice(), cupynumeric::slice(-2, -1)}]);
        v_new[{cupynumeric::slice(), cupynumeric::slice(-1, cupynumeric::open)}].assign(
            v[{cupynumeric::slice(), cupynumeric::slice(1, 2)}]);
        v_new[{cupynumeric::slice(0, 1), cupynumeric::slice()}].assign(
            v[{cupynumeric::slice(-2, -1), cupynumeric::slice()}]);
        v_new[{cupynumeric::slice(-1, cupynumeric::open), cupynumeric::slice()}].assign(
            v[{cupynumeric::slice(1, 2), cupynumeric::slice()}]);

        // Swap: u <- u_new, v <- v_new for next step
        u.assign(u_new);
        v.assign(v_new);
    }

    // Finalize
    legate::finish();
    return 0;
}
