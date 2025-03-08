#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

// #include <julia.h>
// JULIA_DEFINE_FAST_TLS

#define TOTAL_SYS_MEMORY (1 << 14)
#define MAX_ALLOC_SIZE (1 << 10)
uint64_t current_sys_usage = 0;
size_t N = 1000;
size_t n = 0;

pthread_mutex_t lock;

typedef void (*callback_t)(void *);

typedef struct {
  callback_t function;
  void *arg;
} callback_info_t;

callback_t registered_oom_callback = NULL;

void *thread_function(void *arg) {
  callback_info_t *cb_info = (callback_info_t *)arg;
  if (cb_info->function) {
    cb_info->function(cb_info->arg);
  }
  free(cb_info);
  return NULL;
}

void register_callback(callback_t function, void *arg) {
  pthread_t thread;
  callback_info_t *cb_info = malloc(sizeof(callback_info_t));
  if (!cb_info) {
    perror("malloc failed");
    return;
  }
  cb_info->function = function;
  cb_info->arg = arg;

  if (pthread_create(&thread, NULL, thread_function, cb_info) != 0) {
    perror("pthread_create failed");
    free(cb_info);
  }
  pthread_detach(thread);
}

void mapper_alloc(void *alloc, int size) {
  // register a callback if OOM error in mapper
  if (current_sys_usage + size > TOTAL_SYS_MEMORY) {
    if (registered_oom_callback != NULL) {
      register_callback(registered_oom_callback, "Calling GC:: ");
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

// cuNumeric.jl will initialize a Cfunction that it created to call GC.gc()
void mapper_register_oom_callback(callback_t function) {
  registered_oom_callback = function;
}

// fake callback
void handle_out_of_memory(void *arg) {
  uint64_t collected = (rand() % 5) * (rand() % MAX_ALLOC_SIZE);
  printf("(%ld) %s current_sys_usage %ld::: freeing %ld bytes\n", n,
         (char *)arg, current_sys_usage, collected);
  current_sys_usage -= collected;
}

// just for testing
int main() {
  mapper_register_oom_callback(handle_out_of_memory);

  srand(time(NULL));
  for (int i = 0; i < N; i++) {
    n = i;
    size_t size = (rand() % MAX_ALLOC_SIZE) + 1;
    void *ptr = malloc(size);
    mapper_alloc(ptr, size);
    free(ptr);
  }
}