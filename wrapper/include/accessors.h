#include "jlcxx/jlcxx.hpp"
#include "legate.h"
#include "legion.h"
#include "cupynumeric.h"

#include <vector>
#include <type_traits>

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


template<typename T, int n_dims>
struct ExposedAccessorRO{
  using AccessorT = legate::AccessorRO<T, n_dims>;
  using ValueType = T;
  
  static constexpr int_t get_n_dims() {
    return n_dims;
  }
};

template<typename T, int n_dims>
struct ExposedAccessorWO{
  using AccessorT = legate::AccessorWO<T, n_dims>;
  using ValueType = T;
  
  static constexpr int_t get_n_dims() {
    return n_dims;
  }
};

namespace jlcxx {
template<typename T, int n_dims>
struct BuildParameterList<ExposedAccessorRO<T, n_dims>>
{
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
};

template<typename T, int n_dims>
struct BuildParameterList<ExposedAccessorWO<T, n_dims>>
{
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
};
}

struct ApplyAccessorRO
{
  template<typename T, typename n_dims>
  using apply = ExposedAccessorRO<T, n_dims::value>;
};

struct ApplyAccessorWO
{
  template<typename T, typename n_dims>
  using apply = ExposedAccessorWO<T, n_dims::value>;
};


struct WrapAccessorRO {
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {

    using WrappedT = typename TypeWrapperT::type; //ExposedAccessorRO<T,n_dims>
    using LegateAccessorT = typename WrappedT::AccessorT; //legate::AccessorRO<T,n_dims>
    using VT = typename WrappedT::ValueType;
    constexpr int n_dims = WrappedT::get_n_dims();

    //free method
    // does this need to be uint64_t
    wrapped.module().method("read", [n_dims](const LegateAccessorT& acc, const std::vector<uint64_t>& dims) 
    {   
        // feels suboptimal
        // each call to [] in julia will call this
        auto p = Realm::Point<n_dims>(0);
        for(int i = 0; i < n_dims; ++i){
          p[i] = dims[i];
        }
        return acc.read(p);
    });

  }
};

struct WrapAccessorWO {
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {

    using WrappedT = typename TypeWrapperT::type; //ExposedAccessorWO<T,n_dims>
    using LegateAccessorT = typename WrappedT::AccessorT; //legate::AccessorWO<T,n_dims>
    using VT = typename WrappedT::ValueType;
    constexpr int n_dims = WrappedT::get_n_dims();

    //free method
    wrapped.module().method("write", [n_dims](const LegateAccessorT& acc, const std::vector<uint64_t>& dims, VT val)
    {
        // feels suboptimal
        // each call to [] in julia will call this
        auto p = Realm::Point<n_dims>(0);
        for(int i = 0; i < n_dims; ++i){
          p[i] = dims[i];
        }
        return acc.write(p, val);
    });


  }
};


////////////////////////////
////////////////////////////

template<typename T, int n_dims>
struct GetReadAccessor
{
  using ValueType = T;
  
  legate::AccessorRO<ValueType, n_dims> get_read_accessor(cupynumeric::NDArray& arr){
    return arr.get_read_accessor();
  }

  static constexpr int_t get_n_dims() {
    return n_dims;
  }
};

template<typename T, int n_dims>
struct GetWriteAccessor
{
  using ValueType = T;

  legate::AccessorWO<ValueType, n_dims> get_write_accessor(cupynumeric::NDArray& arr){
    return arr.get_write_accessor();
  }

  static constexpr int_t get_n_dims() {
    return n_dims;
  }
};

namespace jlcxx {
template<typename T, int n_dims>
struct BuildParameterList<GetReadAccessor<T, n_dims>>
{
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
};

template<typename T, int n_dims>
struct BuildParameterList<GetWriteAccessor<T, n_dims>>
{
  using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
};
}

struct ApplyGetAccessorRO
{
  template<typename T, typename n_dims>
  using apply = GetReadAccessor<T, n_dims::value>;
};

struct ApplyGetAccessorWO
{
  template<typename T, typename n_dims>
  using apply = GetWriteAccessor<T, n_dims::value>;
};


struct WrapGetAccessorRO{
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {
    using WrappedT = typename TypeWrapperT::type;
    using VT = typename WrappedT::ValueType;
    constexpr int n_dims = WrappedT::get_n_dims(); 

    wrapped.method("get_read_accessor", &WrappedT::get_read_accessor<VT, n_dims>);
  }
};

struct WrapGetAccessorWO{
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {
    using WrappedT = typename TypeWrapperT::type;
    using VT = typename WrappedT::ValueType;
    constexpr int n_dims = WrappedT::get_n_dims(); 

    wrapped.method("get_write_accessor", &WrappedT::get_write_accessor<VT, n_dims>);
  }
};