(in-package #:nanomsg)

(cffi:defcvar "errno" :int)

(define-condition nanomsg-error (error)
  ((code :initarg :rc :initform nil :accessor errno))
  (:report (lambda (c s)
             (with-slots (code) c
               (format s "NANOMSG Error: (~A): ~A" code "TODO convert errno to meaningful string description.")))))

;;; We've done the same stuff in cl-sdl2... maybe these handy macros should move into autowrap?
(defmacro check-rc (form)
  (with-gensyms (rc)
    `(let ((,rc ,form))
       (unless (>= ,rc 0)
         (error 'nanomsg-error :rc *errno*))
       ,rc)))

(defun make-socket (domain protocol)
  (check-rc (nn-socket domain protocol)))
