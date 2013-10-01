(in-package #:nanomsg-ffi)

(autowrap:c-include '(nanomsg autowrap-spec "nanomsg.h")
                    :spec-path '(nanomsg autowrap-spec)
                    :accessor-package #:nanomsg-ffi.accessors
                    :function-package #:nanomsg-ffi.functions
                    :exclude-sources ("/usr/local/lib/clang/3.3/include/(?!stddef.h)"
                                      "/usr/include/(?!stdint.h|bits/types.h|sys/types.h).*"))

