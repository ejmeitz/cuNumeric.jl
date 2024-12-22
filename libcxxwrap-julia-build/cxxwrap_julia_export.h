
#ifndef CXXWRAP_JULIA_EXPORT_H
#define CXXWRAP_JULIA_EXPORT_H

#ifdef CXXWRAP_JULIA_STATIC_DEFINE
#  define CXXWRAP_JULIA_EXPORT
#  define CXXWRAP_JULIA_NO_EXPORT
#else
#  ifndef CXXWRAP_JULIA_EXPORT
#    ifdef cxxwrap_julia_EXPORTS
        /* We are building this library */
#      define CXXWRAP_JULIA_EXPORT __attribute__((visibility("default")))
#    else
        /* We are using this library */
#      define CXXWRAP_JULIA_EXPORT __attribute__((visibility("default")))
#    endif
#  endif

#  ifndef CXXWRAP_JULIA_NO_EXPORT
#    define CXXWRAP_JULIA_NO_EXPORT __attribute__((visibility("hidden")))
#  endif
#endif

#ifndef CXXWRAP_JULIA_DEPRECATED
#  define CXXWRAP_JULIA_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef CXXWRAP_JULIA_DEPRECATED_EXPORT
#  define CXXWRAP_JULIA_DEPRECATED_EXPORT CXXWRAP_JULIA_EXPORT CXXWRAP_JULIA_DEPRECATED
#endif

#ifndef CXXWRAP_JULIA_DEPRECATED_NO_EXPORT
#  define CXXWRAP_JULIA_DEPRECATED_NO_EXPORT CXXWRAP_JULIA_NO_EXPORT CXXWRAP_JULIA_DEPRECATED
#endif

/* NOLINTNEXTLINE(readability-avoid-unconditional-preprocessor-if) */
#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef CXXWRAP_JULIA_NO_DEPRECATED
#    define CXXWRAP_JULIA_NO_DEPRECATED
#  endif
#endif

#endif /* CXXWRAP_JULIA_EXPORT_H */
