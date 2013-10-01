;;;; package.lisp

(defpackage #:nanomsg-ffi)
(defpackage #:nanomsg-ffi.accessors)
(defpackage #:nanomsg-ffi.functions)

(defpackage #:nanomsg
  (:use #:cl #:alexandria #:autowrap.minimal)
  (:import-from :cffi
                #:mem-ref #:with-foreign-objects #:with-foreign-object
                #:foreign-alloc #:foreign-free #:null-pointer-p)
  (:export #:hello))
