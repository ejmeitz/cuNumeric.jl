/* Copyright 2025 Northwestern University,
 *                   Carnegie Mellon University University
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Author(s): David Krasowska <krasow@u.northwestern.edu>
 *            Ethan Meitz <emeitz@andrew.cmu.edu>
 */

#include <regex>

#include "ufi.h"
#include "cupynumeric.h"
#include "legate.h"
#include "legion.h"
#include "cuda.h"

namespace ufi {
    using namespace Legion;

//  struct EvalUDFTaskArgs {
//     void sanity_check(void);

//     uint64_t func_ptr;
//     OutputColumn mask;
//     std::vector<Column<true>> columns;
//     std::vector<FromRawFuture> scalars;
//     friend void deserialize(Deserializer &ctx, EvalUDFTaskArgs &args);
//   };


// // https://github.com/nv-legate/legate.pandas/blob/branch-22.01/src/udf/eval_udf_gpu.cc
// /*static*/ void EvalUDFTask::gpu_variant(const Task *task,
//                                          const std::vector<PhysicalRegion> &regions,
//                                          Context context,
//                                          Runtime *runtime)
// {
//   Deserializer ctx{task, regions};

//   EvalUDFTaskArgs args;
//   deserialize(ctx, args);

// #ifdef DEBUG_PANDAS
//   assert(!args.columns.empty());
// #endif
//   const auto size = args.columns[0].num_elements();

//   args.mask.allocate(size);
//   if (size == 0) return;

//   GPUTaskContext gpu_ctx{};
//   auto stream = gpu_ctx.stream();

//   // A technical note: this future is not used when args.scalars was deserialized,
//   // as the length of args.scalars passed from the Python side doesn't count this.
//   CUfunction func = task->futures.back().get_result<CUfunction>();

//   const uint32_t gridDimX = (size + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;
//   const uint32_t gridDimY = 1;
//   const uint32_t gridDimZ = 1;

//   const uint32_t blockDimX = THREADS_PER_BLOCK;
//   const uint32_t blockDimY = 1;
//   const uint32_t blockDimZ = 1;

//   size_t buffer_size = (args.columns.size() + 1) * sizeof(void *);
//   // TODO: We may see alignment issues with the arguments smaller than 4B
//   for (auto &scalar : args.scalars) buffer_size += scalar.size_;
//   buffer_size += sizeof(size_t);

//   std::vector<char> arg_buffer(buffer_size);
//   char *raw_arg_buffer = arg_buffer.data();

//   auto p                        = raw_arg_buffer;
//   *reinterpret_cast<void **>(p) = args.mask.raw_column_untyped();
//   p += sizeof(void *);

//   for (auto &column : args.columns) {
//     *reinterpret_cast<const void **>(p) = column.raw_column_untyped_read();
//     p += sizeof(void *);
//   }

//   for (auto &scalar : args.scalars) {
//     memcpy(p, scalar.rawptr_, scalar.size_);
//     p += scalar.size_;
//   }

//   memcpy(p, &size, sizeof(size_t));

//   void *config[] = {
//     CU_LAUNCH_PARAM_BUFFER_POINTER,
//     static_cast<void *>(raw_arg_buffer),
//     CU_LAUNCH_PARAM_BUFFER_SIZE,
//     &buffer_size,
//     CU_LAUNCH_PARAM_END,
//   };

//   CUresult status = cuLaunchKernel(
//     func, gridDimX, gridDimY, gridDimZ, blockDimX, blockDimY, blockDimZ, 0, stream, NULL, config);
//   if (status != CUDA_SUCCESS) {
//     fprintf(stderr, "Failed to launch a CUDA kernel\n");
//     exit(-1);
//   }

//   if (!args.mask.nullable()) return;

//   bool initialized = false;
//   Bitmask bitmask  = args.mask.bitmask();
//   for (auto &column : args.columns) {
//     if (!column.nullable()) continue;
//     Bitmask to_merge = column.read_bitmask();
//     if (initialized)
//       intersect_bitmasks(bitmask, bitmask, to_merge, stream);
//     else
//       to_merge.copy(bitmask, stream);
//   }
// }



// https://github.com/nv-legate/legate.pandas/blob/branch-22.01/src/udf/load_ptx.cc
/*static*/ void LoadPTXTask::gpu_variant(legate::TaskContext context)
{
    std::string ptx = context.scalar(0).value<std::string>();

    auto output   = context.output(0);
    auto output_acc = output.data().write_accessor<uint64_t, 1>();

    const unsigned num_options = 4;
    const size_t buffer_size   = 16384;
    std::vector<char> log_info_buffer(buffer_size);
    std::vector<char> log_error_buffer(buffer_size);
    CUjit_option jit_options[] = {
        CU_JIT_INFO_LOG_BUFFER,
        CU_JIT_INFO_LOG_BUFFER_SIZE_BYTES,
        CU_JIT_ERROR_LOG_BUFFER,
        CU_JIT_ERROR_LOG_BUFFER_SIZE_BYTES,
    };
    void *option_vals[] = {
        static_cast<void *>(log_info_buffer.data()),
        reinterpret_cast<void *>(buffer_size),
        static_cast<void *>(log_error_buffer.data()),
        reinterpret_cast<void *>(buffer_size),
    };

    CUmodule module;
    CUresult result = cuModuleLoadDataEx(&module, static_cast<const void*>(ptx.c_str()), num_options, jit_options, option_vals);
    if (result != CUDA_SUCCESS) {
        if (result == CUDA_ERROR_OPERATING_SYSTEM) {
        fprintf(stderr,
                "ERROR: Device side asserts are not supported by the "
                "CUDA driver for MAC OSX, see NVBugs 1628896.\n");
        exit(-1);
        } else if (result == CUDA_ERROR_NO_BINARY_FOR_GPU) {
        fprintf(stderr, "ERROR: The binary was compiled for the wrong GPU architecture.\n");
        exit(-1);
        } else {
        fprintf(stderr, "Failed to load CUDA module! Error log: %s\n", log_error_buffer.data());
    #if CUDA_VERSION >= 6050
        const char *name, *str;
        assert(cuGetErrorName(result, &name) == CUDA_SUCCESS);
        assert(cuGetErrorString(result, &str) == CUDA_SUCCESS);
        fprintf(stderr, "CU: cuModuleLoadDataEx = %d (%s): %s\n", result, name, str);
    #else
        fprintf(stderr, "CU: cuModuleLoadDataEx = %d\n", result);
    #endif
        exit(-1);
        }
    }

    std::cmatch line_match;
    // there should be a built in find name of ufi function - pat
    bool match = std::regex_search(ptx.c_str(), line_match, std::regex(".visible .entry [_a-zA-Z0-9$]+"));

    const auto &matched_line = line_match.begin()->str();
    auto fun_name            = matched_line.substr(matched_line.rfind(" ") + 1, matched_line.size());

    CUfunction hfunc;
    result = cuModuleGetFunction(&hfunc, module, fun_name.c_str());
    assert(result == CUDA_SUCCESS);
    auto int_func = reinterpret_cast<uint64_t>(hfunc);

    // this is actually dumb
    cudaMemcpy(output_acc.ptr(Realm::Point<1>(0)), &int_func, sizeof(uint64_t), cudaMemcpyHostToDevice);
    // this doesn't work as we are on a GPU task due to necessary GPU context
    // Realm::Point<1> p(0);
    // output_acc.write(p, int_func);
    }
} // end ufi

// https://github.com/nv-legate/cupynumeric/blob/7e554b576ccc2d07a86986949cea79e56c690fe1/src/cupynumeric/ndarray.cc#L2120
// Copied method from the above link.
legate::LogicalStore broadcast(const std::vector<uint64_t>& shape,
                                        legate::LogicalStore& store) 
{
  int32_t diff = static_cast<int32_t>(shape.size()) - store.dim();

  auto result = store;
  for (int32_t dim = 0; dim < diff; ++dim) {
    result = result.promote(dim, shape[dim]);
  }

  std::vector<uint64_t> orig_shape = result.extents().data();
  for (uint32_t dim = 0; dim < shape.size(); ++dim) {
    if (orig_shape[dim] != shape[dim]) {

      result = result.project(dim, 0).promote(dim, shape[dim]);
    }
  }

  return result;
}

legate::Library get_lib() {
    auto runtime = cupynumeric::CuPyNumericRuntime::get_runtime();
    return runtime->get_library();
}

cupynumeric::NDArray new_task(int32_t opcode, cupynumeric::NDArray rhs1, cupynumeric::NDArray rhs2, cupynumeric::NDArray output, int32_t N) {
    auto runtime = legate::Runtime::get_runtime();
    auto library = get_lib();
    auto task = runtime->create_task(library, legate::LocalTaskID{opcode});

    auto& out_shape = output.shape();
    auto rhs1_temp = rhs1.get_store();
    auto rhs2_temp = rhs2.get_store();
    auto rhs1_store = broadcast(out_shape, rhs1_temp);
    auto rhs2_store = broadcast(out_shape, rhs2_temp);

    auto p_lhs  = task.add_output(output.get_store());
    auto p_rhs1 = task.add_input(rhs1_store);
    auto p_rhs2 = task.add_input(rhs2_store);

    task.add_scalar_arg(legate::Scalar(N));
    task.add_constraint(legate::align(p_lhs, p_rhs1));
    task.add_constraint(legate::align(p_rhs1, p_rhs2));

    runtime->submit(std::move(task));
    return output;
}


legate::LogicalStore ptx_task(std::string ptx) {
    auto runtime = legate::Runtime::get_runtime();
    auto library = get_lib();
    auto task = runtime->create_task(library, legate::LocalTaskID{ufi::LOAD_PTX_TASK});
    task.add_scalar_arg(legate::Scalar(ptx));

    auto scalar_store  = runtime->create_store({1}, legate::uint64(), false);
    task.add_output(scalar_store);

    runtime->submit(std::move(task));
    return scalar_store;
}



void register_tasks() {
    auto library = get_lib();
    ufi::LoadPTXTask::register_variants(library);
}


void wrap_cuda_methods(jlcxx::Module& mod){
    mod.method("register_tasks", &register_tasks);
    mod.method("get_library", &get_lib);
    mod.method("new_task", &new_task);
    mod.method("ptx_task", &ptx_task);
}