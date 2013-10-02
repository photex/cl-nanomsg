;;;; package.lisp

(defpackage #:nanomsg-ffi)
(defpackage #:nanomsg-ffi.accessors)
(defpackage #:nanomsg-ffi.functions)

(defpackage #:nanomsg
  (:use #:cl #:alexandria #:autowrap.minimal
        #:nanomsg-ffi.accessors #:nanomsg-ffi.functions)
  (:import-from :cffi
                #:mem-ref #:with-foreign-objects #:with-foreign-object
                #:foreign-alloc #:foreign-free #:null-pointer-p)
  (:export #:make-socket
           #:close-socket))
