#include "legate.h"
#include "cupynumeric.h"
#include "realm/cmdline.h"

#include <cassert>
#include <iostream>

using namespace cupynumeric;

int main(int argc, char** argv)
{
    // Initialize Legate and cupynumeric
    legate::start();
    initialize(argc, argv);

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
    auto val = legate::Scalar(1.0);
    auto u = full({N, N}, val);
    auto v = zeros({N, N});


    // Generate a 150x150 array of random float64 values
    auto randU = cupynumeric::random({150, 150});
    auto randV = cupynumeric::random({150, 150});
    // Assign these to the top-left corner
    u[{slice(0, 150), slice(0, 150)}].assign(randU);
    v[{slice(0, 150), slice(0, 150)}].assign(randV);

    // Create temporary arrays to hold updated values each iteration
    auto u_new = cupynumeric::zeros({N, N});
    auto v_new = cupynumeric::zeros({N, N});

    auto _val = legate::Scalar(1.0);
    auto _ones = full({N, N}, _val);

    for (int step = 0; step < n_steps; ++step) {
        // Extract interior slices of u, v
        auto centerU = u[{slice(1, -1), slice(1, -1)}];
        auto centerV = v[{slice(1, -1), slice(1, -1)}];

        // Reaction terms:
        //   F_u = -u*(v^2) + f*(1-u)
        //   F_v =  u*(v^2) - (f+k)*v
        auto v_sq = centerV * centerV;

        // experimenting a bit. c++ API thinks all scalars are 1D rects? not sure whats going on here.
        // auto F_u  = (full({N, N}, legate::Scalar(-1.0)) * centerU * v_sq) + full({N, N}, legate::Scalar(f)) + (full({N, N}, legate::Scalar(-1.0 * f)) * centerU);
        auto F_u  = (-centerU * v_sq) + f * (_ones - centerU);
        auto F_v  = ( centerU * v_sq) - (f + k) * centerV;

        // 2D Laplacian of u
        auto upU    = u[{slice(0, -2),   slice(1, -1)}];
        auto downU  = u[{slice(2, open), slice(1, -1)}];
        auto leftU  = u[{slice(1, -1), slice(0, -2)}];
        auto rightU = u[{slice(1, -1), slice(2, open)}];
        auto partialVertU   = upU - (2.0 * centerU) + downU;
        auto partialHorizU  = leftU - (2.0 * centerU) + rightU;
        auto lapU           = partialVertU + partialHorizU;
        lapU                = lapU / (dx * dx);

        // 2D Laplacian of v
        auto upV    = v[{slice(0, -2),   slice(1, -1)}];
        auto downV  = v[{slice(2, open), slice(1, -1)}];
        auto leftV  = v[{slice(1, -1), slice(0, -2)}];
        auto rightV = v[{slice(1, -1), slice(2, open)}];
        auto partialVertV   = upV - (2.0 * centerV) + downV;
        auto partialHorizV  = leftV - (2.0 * centerV) + rightV;
        auto lapV           = partialVertV + partialHorizV;
        lapV                = lapV / (dx * dx);

        // Forward-Euler update for the interior
        auto interiorU_new = u_new[{slice(1, -1), slice(1, -1)}];
        auto interiorV_new = v_new[{slice(1, -1), slice(1, -1)}];
        interiorU_new.assign(legate::Scalar(centerU + dt * (c_u * lapU + F_u)));
        interiorV_new.assign(legate::Scalar(centerV + dt * (c_v * lapV + F_v)));

        // Apply periodic boundary conditions: u_new
        u_new[{slice(), slice(0, 1)}].assign(
            u[{slice(), slice(-2, -1)}]);
        u_new[{slice(), slice(-1, open)}].assign(
            u[{slice(), slice(1, 2)}]);
        u_new[{slice(0, 1), slice()}].assign(
            u[{slice(-2, -1), slice()}]);
        u_new[{slice(-1, open), slice()}].assign(
            u[{slice(1, 2), slice()}]);

        // Apply periodic boundary conditions: v_new
        v_new[{slice(), slice(0, 1)}].assign(
            v[{slice(), slice(-2, -1)}]);
        v_new[{slice(), slice(-1, open)}].assign(
            v[{slice(), slice(1, 2)}]);
        v_new[{slice(0, 1), slice()}].assign(
            v[{slice(-2, -1), slice()}]);
        v_new[{slice(-1, open), slice()}].assign(
            v[{slice(1, 2), slice()}]);

        // Swap: u <- u_new, v <- v_new for next step
        u.assign(u_new);
        v.assign(v_new);
    }

    // Finalize
    return legate::finish();
}
