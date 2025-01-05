#include "jlcxx/jlcxx.hpp"
#include "legate.h"
#include "legion.h"
#include "cupynumeric.h"

#include <vector>
#include <type_traits>
#include <iostream>

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


// template<typename T, int n_dims>
// struct ExposedAccessorRO{
//   using AccessorT = legate::AccessorRO<T, n_dims>;
//   using ValueType = T;
  
//   static constexpr int_t get_n_dims() {
//     return n_dims;
//   }
// };

// template<typename T, int n_dims>
// struct ExposedAccessorWO{
//   using AccessorT = legate::AccessorWO<T, n_dims>;
//   using ValueType = T;
  
//   static constexpr int_t get_n_dims() {
//     return n_dims;
//   }
// };

namespace jlcxx {

template <legion_privilege_mode_t PM, typename FT, int N>
struct BuildParameterList<Legion::FieldAccessor<PM, FT, N, long long, Realm::AffineAccessor<FT, N, long long>, false>
{
  using type = ParameterList<std::integral_constant<uint32_t, PM>, FT, std::integral_constant<int_t, N>>;
};

// template<typename T, int n_dims>
// struct BuildParameterList<ExposedAccessorRO<T, n_dims>>
// {
//   using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
// };

// template<typename T, int n_dims>
// struct BuildParameterList<ExposedAccessorWO<T, n_dims>>
// {
//   using type = ParameterList<T, std::integral_constant<int_t, n_dims>>;
// };
}

struct ApplyFieldAccessor
{
  template<typename PM, typename FT, typename N>
  using apply = Legion::FieldAccessor<PM::value, FT, N::value, long long, Realm::AffineAccessor<FT, N::value, long long>, false>;
};

// struct ApplyAccessorRO
// {
//   template<typename T, typename n_dims>
//   using apply = ExposedAccessorRO<T, n_dims::value>;
// };

// struct ApplyAccessorWO
// {
//   template<typename T, typename n_dims>
//   using apply = ExposedAccessorWO<T, n_dims::value>;
// };


struct WrapFieldAccessor{
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {}
};

// template<typename T, int32_t DIM>
// legate::AccessorRO<T, DIM> _get_read_accessor(cupynumeric::NDArray& arr){
//   return arr.get_read_accessor<T, DIM>();
// }

// struct GetAccessorROFreeMethod
// {
//   GetAccessorROFreeMethod(jlcxx::Module& mod) : m_module(mod)
//   {
//   }

//   template<typename T>
//   void operator()()
//   {
//     // using LegateAccessorT = typename T::AccessorT;
//     // // using VT = typename T::ValueType;
//     // constexpr int n_dims = T::get_n_dims();

//     m_module.method("get_read_accessor", [](cupynumeric::NDArray& arr) {
//       std::cout << "IN HERE" << std::endl;
//       // using VT = typename T::ValueType;
//       // return arr.get_read_accessor<VT, n_dims>();
//     });
//   }

//   jlcxx::Module& m_module;
// };

// struct WrapAccessorRO {

  
//   template <typename TypeWrapperT>
//   void operator()(TypeWrapperT&& wrapped) {

//     using WrappedT = typename TypeWrapperT::type; //ExposedAccessorRO<T,n_dims>
//     using LegateAccessorT = typename WrappedT::AccessorT; //legate::AccessorRO<T,n_dims>
//     using VT = typename WrappedT::ValueType;
//     constexpr int n_dims = WrappedT::get_n_dims();

//     //free method
//     // does this need to be uint64_t
//     wrapped.module().method("read", [n_dims](const LegateAccessorT& acc, const std::vector<uint64_t>& dims) 
//     {   
//         // feels suboptimal
//         // each call to [] in julia will call this
//         auto p = Realm::Point<n_dims>(0);
//         for(int i = 0; i < n_dims; ++i){
//           p[i] = dims[i];
//         }
//         return acc.read(p);
//     });

//     // this lets us wrap the tempalted getters with the same types
//     // wrapped.module().method("get_read_accessor", &_get_read_accessor<VT, n_dims>);
//   }
// };

// template<typename T, int32_t DIM>
// legate::AccessorWO<T, DIM> _get_write_accessor(cupynumeric::NDArray& arr){
//   return arr.get_write_accessor<T, DIM>();
// }

// struct WrapAccessorWO {
//   template <typename TypeWrapperT>
//   void operator()(TypeWrapperT&& wrapped) {

//     using WrappedT = typename TypeWrapperT::type; //ExposedAccessorWO<T,n_dims>
//     using LegateAccessorT = typename WrappedT::AccessorT; //legate::AccessorWO<T,n_dims>
//     using VT = typename WrappedT::ValueType;
//     constexpr int n_dims = WrappedT::get_n_dims();

//     //free methods
//     wrapped.module().method("write", [n_dims](const LegateAccessorT& acc, const std::vector<uint64_t>& dims, VT val)
//     {
//         // feels suboptimal
//         // each call to [] in julia will call this
//         auto p = Realm::Point<n_dims>(0);
//         for(int i = 0; i < n_dims; ++i){
//           p[i] = dims[i];
//         }
//         return acc.write(p, val);
//     });

//     // this lets us wrap the tempalted getters with the same types
//     wrapped.module().method("get_write_accessor", &_get_write_accessor<VT, n_dims>);

//   }
// };