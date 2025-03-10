#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <julia.h>
#include <uv.h>
#include <callback.h>

#define TOTAL_SYS_MEMORY (1 << 14)
#define MAX_ALLOC_SIZE (1 << 10)

namespace callback {
  uint64_t current_sys_usage = 0;
  size_t N = 1000;
  size_t n = 0;

  uv_async_t async_handle;
  uv_loop_t* loop;

  using callback_t = void (*)(void*);

  typedef struct {
    callback_t function;
    void *arg;
  } callback_info_t;

  callback_t registered_oom_callback = NULL;

  void notify_callback(uv_async_t* handle) {
      registered_oom_callback((void*)handle->data);
  }

  void *thread_function(void *arg) {
    jl_adopt_thread();
    callback_info_t *cb_info = (callback_info_t *)arg;

    if (!cb_info->function) {
      // cb_info->function(cb_info->arg);
      perror("function ptr NULL\n");
      return NULL;
    }

    async_handle.data = cb_info->arg; // set data
    uv_async_send(&async_handle);

    free(cb_info);
    return NULL;
  }

  void register_callback(callback_t function, uv_loop_t* _loop, void* arg) {
    uv_async_init(_loop, &async_handle, notify_callback);

    pthread_t thread;
    callback_info_t *cb_info = (callback_info_t*)malloc(sizeof(callback_info_t));
    if (!cb_info) {
      perror("malloc failed");
      return;
    }
    cb_info->function = function;
    cb_info->arg = arg;

    if (pthread_create(&thread, NULL, thread_function, cb_info) != 0) {
      perror("pthread_create failed");
      free(cb_info);
      return;
    }
    pthread_detach(thread);

    uv_run(_loop, UV_RUN_DEFAULT);  // Use UV_RUN_DEFAULT (blocking) to process events
  }
  
  void mapper_alloc(uint64_t size) {
    // register a callback if OOM error in mapper
    if (current_sys_usage + size > TOTAL_SYS_MEMORY) {
      if (registered_oom_callback != NULL) {
        register_callback(registered_oom_callback, loop, (void*)"GC running"); // loop is a global here
      } else {
        fprintf(stderr,
                "Out of memory. Register a callback to handle OOM mapping "
                "failures: mapper_register_oom_callback(). Exiting. \n");
        exit(-1);
      }
    } else {
      current_sys_usage += size;
    }
  }

  void mapper_remove_usage(uint64_t remove) {
      current_sys_usage -= remove; 
  }

  // cuNumeric.jl will initialize a Cfunction that it created to call GC.gc()
  void mapper_register_oom_callback(void* function) {
      fprintf(stderr, "Registered a OOM callback function\n");
      jl_init();
      loop = uv_default_loop();

      registered_oom_callback = reinterpret_cast<callback_t>(function);
  }
};