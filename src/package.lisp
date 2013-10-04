;;;; package.lisp

(defpackage #:nanomsg-ffi)
(defpackage #:nanomsg-ffi.accessors)
(defpackage #:nanomsg-ffi.functions)

(defpackage #:nanomsg
  (:use #:cl #:alexandria #:autowrap.minimal
        #:nanomsg-ffi.accessors #:nanomsg-ffi.functions)
  (:import-from :cffi
                #:mem-ref #:with-foreign-objects #:with-foreign-object
                #:with-foreign-string #:foreign-type-size
                #:foreign-alloc #:foreign-free #:null-pointer-p)
  (:export #:errno
           #:strerror
           ;; constants
           #:+sockaddrmax+
           #:+eagain+
           #:+msg-max-len+
           ;; api
           #:term
           #:make-socket
           #:close-socket
           #:set-socket-option
           #:get-socket-option
           #:bind
           #:connect
           #:shutdown
           #:alloc-msg
           #:free-msg
           #:send
           #:recv
           ))
