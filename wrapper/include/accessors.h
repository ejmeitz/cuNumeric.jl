#include <iostream>
#include <type_traits>
#include <vector>

#include "cupynumeric.h"
#include "jlcxx/jlcxx.hpp"
#include "legate.h"
#include "legion.h"

using coord_t = long long;

// To auto-magically generate templated classes and their
// respective member functions you must define a `BuildParameterList`
// which allows `apply_combination` to work. You also need to define a
// struct which defines `apply` as a type for how to create the type properly
// with a given set of template parameters. Then you need a class to wrap the
// template instantiation. This should overload the call, operator(), which is
// passed as a functor to apply_combiation.....what a mess

// I also defined some wrapper classes to expose the template parameters
// since they are not always public in legate or cupynumeric and this
// is easier than making a PR there.



// We can used instances of this struct to function parameters
// to differentiate functions for Julia multiple dispatch to work
template<typename... Args>
struct TypeContainer{};

template<typename T, int n_dims>
using AccessorTypeContainer = TypeContainer<T, std::integral_constant<int, n_dims>>;

struct EmptyWrapper{
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {}
};


////////////////////

template <typename T, int n_dims>
struct ExposedAccessorRO {
  using AccessorT = legate::AccessorRO<T, n_dims>;
  using ValueType = T;

  static constexpr int_t get_n_dims() { return n_dims; }
};

template <typename T, int n_dims>
struct ExposedAccessorWO {
  using AccessorT = legate::AccessorWO<T, n_dims>;
  using ValueType = T;

  static constexpr int_t get_n_dims() { return n_dims; }
};

///////////////////////////////

namespace jlcxx {

template <legion_privilege_mode_t PM, typename FT, int n_dims>
struct BuildParameterList<
    Legion::FieldAccessor<PM, FT, n_dims, coord_t,
                          Realm::AffineAccessor<FT, n_dims, coord_t>, false>> {
  using type =
      ParameterList<std::integral_constant<legion_privilege_mode_t, PM>, FT,
                    std::integral_constant<int_t, n_dims>>;
};

template <typename T, int n_dims>
struct BuildParameterList<ExposedAccessorRO<T, n_dims>> {
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
};

template <typename T, int n_dims>
struct BuildParameterList<ExposedAccessorWO<T, n_dims>> {
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
};

//specializaiton of TypeContainer for accessors
template <typename T, int n_dims>
struct BuildParameterList<AccessorTypeContainer<T, n_dims>>{
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>; 
};
}  // namespace jlcxx

///////////////////////

struct ApplyAccessorTypeContainer{
  template <typename T, typename n_dims>
  using apply = AccessorTypeContainer<T, n_dims::value>;
};

struct ApplyAccessorRO {
  template <typename T, typename n_dims>
  using apply = ExposedAccessorRO<T, n_dims::value>;
};

struct ApplyAccessorWO {
  template <typename T, typename n_dims>
  using apply = ExposedAccessorWO<T, n_dims::value>;
};

struct ApplyFieldAccessor {
  template <typename PM, typename FT, typename n_dims>
  using apply =
      Legion::FieldAccessor<PM::value, FT, n_dims::value, coord_t,
                            Realm::AffineAccessor<FT, n_dims::value, coord_t>,
                            false>;
};

//////////////////////////////

// Need the extra type container parameters
// to differentaite betwen functions in Julia
template <typename T, int32_t DIM>
legate::AccessorRO<T, DIM> _get_read_accessor(cupynumeric::NDArray& arr, AccessorTypeContainer<T, DIM> tc) {
  return arr.get_read_accessor<T, DIM>();
}

template <typename T, int32_t DIM>
legate::AccessorWO<T, DIM> _get_write_accessor(cupynumeric::NDArray& arr, AccessorTypeContainer<T, DIM> tc) {
  return arr.get_write_accessor<T, DIM>();
}


struct WrapAccessorRO {
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {
    using WrappedT =
        typename TypeWrapperT::type;  // ExposedAccessorRO<T,n_dims>
    using LegateAccessorT =
        typename WrappedT::AccessorT;  // legate::AccessorRO<T,n_dims>
    using VT = typename WrappedT::ValueType;
    constexpr int n_dims = WrappedT::get_n_dims();

    // free method
    //  does this need to be uint64_t
    wrapped.module().method("read",
                            [](const LegateAccessorT& acc,
                                     const std::vector<uint64_t>& dims) -> auto {
                              // feels suboptimal
                              // each call to [] in julia will call this
                              auto p = Realm::Point<n_dims>(0);
                              for (int i = 0; i < n_dims; ++i) {
                                p[i] = dims[i];
                              }
                              return acc.read(p);
                            });

    // this lets us wrap the tempalted getters with the same types
    wrapped.module().method("get_read_accessor", &_get_read_accessor<VT, n_dims>);
  }
};

struct WrapAccessorWO {
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {
    using WrappedT =
        typename TypeWrapperT::type;  // ExposedAccessorWO<T,n_dims>
    using LegateAccessorT =
        typename WrappedT::AccessorT;  // legate::AccessorWO<T,n_dims>
    using VT = typename WrappedT::ValueType;
    constexpr int n_dims = WrappedT::get_n_dims();

    // free methods
    wrapped.module().method(
        "write", [](const LegateAccessorT& acc,
                          const std::vector<uint64_t>& dims, VT val) -> auto {
          // feels suboptimal
          // each call to [] in julia will call this
          auto p = Realm::Point<n_dims>(0);
          for (int i = 0; i < n_dims; ++i) {
            p[i] = dims[i];
          }
          return acc.write(p, val);
        });

    // this lets us wrap the tempalted getters with the same types
    wrapped.module().method("get_write_accessor", &_get_write_accessor<VT, n_dims>);
  }
};