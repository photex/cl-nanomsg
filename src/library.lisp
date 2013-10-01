(in-package :nanomsg)

(cffi:define-foreign-library libnanomsg
  (:darwin (:default "libnanomsg"))
  (:unix (:or "libnanomsg.so.0.0.1" "libnanomsg.so.0" "libnanomsg"))
  (t (:default "libnanomsg")))

(cffi:use-foreign-library libnanomsg)

