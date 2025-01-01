#include "jlcxx/jlcxx.hpp"
#include "legate.h"
#include <vector>

namespace jlcxx {

// good example of this
// https://github.com/barche/cxxwrap-juliacon2020/blob/master/eigen/sample-solution/jleigen/jleigen.cpp
template<typename T, int n_dims>
struct BuildParameterList<legate::AccessorRO<T, n_dims>>
{
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
};

template<typename T, int n_dims>
struct BuildParameterList<legate::AccessorWO<T, n_dims>>
{
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
};

}

struct ApplyAccessorRO
{
  template<typename T, typename n_dims> using apply = legate::AccessorRO<T, n_dims::value>;
};

struct ApplyAccessorWO
{
  template<typename T, typename n_dims> using apply = legate::AccessorWO<T, n_dims::value>;
};


struct WrapAccessorRO {
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {
    using WrappedT = typename TypeWrapperT::type;

    // no idea why this doesnt work
    // int DimT = WrappedT::N;

    // wrapped.method("read", &WrappedT::read);

    //free method
    wrapped.module().method("acc_read", [] (const WrappedT& acc, std::vector<uint64_t> dims) {
        // auto p = Realm::make_point(dims);
        // return acc.read(p);
        return 0;
    });
  }
};

struct WrapAccessorWO {
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {
    using WrappedT = typename TypeWrapperT::type;

    // from template names defined in legate/typdedefs.h
    // int DimT = WrappedT::N;

    // wrapped.method("write", &WrappedT::write);
  }
};