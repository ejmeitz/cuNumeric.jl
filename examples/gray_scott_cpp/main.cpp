#include <cassert>
#include <iostream>

#include "cupynumeric.h"

#include "cupynumeric/ndarray.h"

#include "legate.h"
#include "realm/cmdline.h"

using namespace cupynumeric;

int main(int argc, char** argv) {
  // Initialize Legate and cupynumeric
  legate::start();
  initialize(argc, argv);

  // Problem parameters
  const auto  dx = legate::Scalar{1.0};
  //const auto dx_sq = legate::Scalar{1.0}; // hardcoded should be dx*dx
  const auto dt = legate::Scalar{1.0 / 5.0}; //hardcoded should be dx / 5
  //const auto  c_u = legate::Scalar{1.0};
  const auto c_v = legate::Scalar{0.3};
  const auto f = legate::Scalar{0.03};
  const auto k = legate::Scalar{0.06};
  const auto f_plus_k = legate::Scalar{0.03 + 0.06}; // hard coded to be f + k

  // Grid size and number of steps
  const int N = 1000;
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

  auto _ones = full({N, N}, legate::Scalar(1.0));

  for (int step = 0; step < n_steps; ++step) {
    // Extract interior slices of u, v
    NDArray centerU = u[{slice(1, -1), slice(1, -1)}];
    NDArray centerV = v[{slice(1, -1), slice(1, -1)}];

    NDArray v_sq = centerV * centerV;

    NDArray centerU_negative = u[{slice(1, -1), slice(1, -1)}];
    NDArray F_u_LHS = u[{slice(1, -1), slice(1, -1)}];

    centerU_negative.unary_op(CuPyNumericUnaryOpCode::CUPYNUMERIC_UOP_NEGATIVE, centerU); // -u

    NDArray _f = full({N-1, N-1}, f);
    NDArray F_u = centerU_negative * v_sq + _f * (_ones + centerU_negative); // -u*(v^2) + f*(1-u)

    NDArray _f_plus_k = full({N-1, N-1}, f_plus_k);

    auto fpktimev_neg = centerV * _f_plus_k;
    fpktimev_neg.unary_op(CuPyNumericUnaryOpCode::CUPYNUMERIC_UOP_NEGATIVE, fpktimev_neg); // - (f+k)*v
    NDArray F_v = (centerU * v_sq) + fpktimev_neg; //  u*(v^2) - (f+k)*v

    // 2D Laplacian of u
    NDArray upU = u[{slice(0, -2), slice(1, -1)}];
    NDArray downU = u[{slice(2, open), slice(1, -1)}];
    NDArray leftU = u[{slice(1, -1), slice(0, -2)}];
    NDArray rightU = u[{slice(1, -1), slice(2, open)}];

    auto two_centerU_negative = centerU + centerU;
    two_centerU_negative.unary_op(CuPyNumericUnaryOpCode::CUPYNUMERIC_UOP_NEGATIVE, two_centerU_negative); // -2u

    NDArray partialVertU = upU + two_centerU_negative + downU;
    NDArray partialHorizU = leftU + two_centerU_negative + rightU;
    NDArray lapU = partialVertU + partialHorizU;
    //lapU = lapU / dx_sq;

    // 2D Laplacian of v
    NDArray upV = v[{slice(0, -2), slice(1, -1)}];
    NDArray downV = v[{slice(2, open), slice(1, -1)}];
    NDArray leftV = v[{slice(1, -1), slice(0, -2)}];
    NDArray rightV = v[{slice(1, -1), slice(2, open)}];

    auto two_centerV_negative =  centerV + centerV;
    two_centerV_negative.unary_op(CuPyNumericUnaryOpCode::CUPYNUMERIC_UOP_NEGATIVE, two_centerV_negative); // -2v

    NDArray partialVertV = upV + two_centerV_negative + downV;
    NDArray partialHorizV = leftV + two_centerV_negative + rightV;
    NDArray lapV = partialVertV + partialHorizV;
    //lapV = lapV / dx_sq;

    // Forward-Euler update for the interior
    NDArray interiorU_new = u_new[{slice(1, -1), slice(1, -1)}];
    NDArray interiorV_new = v_new[{slice(1, -1), slice(1, -1)}];
    NDArray _dt = full({N-1, N-1}, dt);
    NDArray _c_v = full({N-1, N-1}, c_v);

    interiorU_new.assign(centerU + _dt * (lapU + F_u));
    interiorV_new.assign(centerV + _dt * ((lapV * _c_v) + F_v));

    // Apply periodic boundary conditions: u_new
    u_new[{slice(), slice(0, 1)}].assign(u[{slice(), slice(-2, -1)}]);
    u_new[{slice(), slice(-1, open)}].assign(u[{slice(), slice(1, 2)}]);
    u_new[{slice(0, 1), slice()}].assign(u[{slice(-2, -1), slice()}]);
    u_new[{slice(-1, open), slice()}].assign(u[{slice(1, 2), slice()}]);

    // Apply periodic boundary conditions: v_new
    v_new[{slice(), slice(0, 1)}].assign(v[{slice(), slice(-2, -1)}]);
    v_new[{slice(), slice(-1, open)}].assign(v[{slice(), slice(1, 2)}]);
    v_new[{slice(0, 1), slice()}].assign(v[{slice(-2, -1), slice()}]);
    v_new[{slice(-1, open), slice()}].assign(v[{slice(1, 2), slice()}]);

    // Swap: u <- u_new, v <- v_new for next step
    u.assign(u_new);
    v.assign(v_new);
  }

  // Finalize
  return legate::finish();
}
