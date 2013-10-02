(in-package #:nanomsg-ffi)

(autowrap:c-include '(nanomsg autowrap-spec "nanomsg.h")
                    :spec-path '(nanomsg autowrap-spec)
                    :accessor-package #:nanomsg-ffi.accessors
                    :function-package #:nanomsg-ffi.functions)

