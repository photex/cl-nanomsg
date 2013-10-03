(in-package #:nanomsg)

(cffi:defcvar "errno" :int64)

(define-condition nanomsg-error (error)
  ((err-msg :initarg :msg :initform nil :accessor err-msg))
  (:report (lambda (c s)
             (with-slots (err-msg) c
               (format s "NANOMSG Error: ~A" err-msg)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; utils

(defmacro domain-constant (domain)
  (case domain
    (:sp nanomsg-ffi:+af-sp+)
    (:sp-raw nanomsg-ffi:+af-sp-raw+)
    (t -1)))

(defmacro protocol-constant (protocol)
  (case protocol
    (:pub nanomsg-ffi:+nn-pub+)
    (:sub nanomsg-ffi:+nn-sub+)
    (:req nanomsg-ffi:+nn-req+)
    (:rep nanomsg-ffi:+nn-rep+)
    (:pair nanomsg-ffi:+nn-pair+)
    (:surveyor nanomsg-ffi:+nn-surveyor+)
    (:respondent nanomsg-ffi:+nn-respondent+)
    (:push nanomsg-ffi:+nn-push+)
    (:pull nanomsg-ffi:+nn-pull+)
    (:bus nanomsg-ffi:+nn-bus+)
    (t -1)))

(defmacro transport-constant (transport)
  (case transport
    (:tcp nanomsg-ffi:+nn-tcp+)
    (:inproc nanomsg-ffi:+nn-inproc+)
    (:ipc nanomsg-ffi:+nn-ipc+)
    (t -1)))

(defmacro sockopt-constant (option)
  (case option
    ;; :sol-socket options
    (:linger nanomsg-ffi:+nn-linger+)
    (:sndbuf nanomsg-ffi:+nn-sndbuf+)
    (:rcvbuf nanomsg-ffi:+nn-rcvbuf+)
    (:sndtimeo nanomsg-ffi:+nn-sndtimeo+)
    (:rcvtimeo nanomsg-ffi:+nn-rcvtimeo+)
    (:reconnect-ivl nanomsg-ffi:+nn-reconnect-ivl+)
    (:reconnect-ivl-max nanomsg-ffi:+nn-reconnect-ivl-max+)
    (:sndprio nanomsg-ffi:+nn-sndprio+)
    (:ipv4only nanomsg-ffi:+nn-ipv4only+)
    ;; :req socket options
    (:req-resend-ivl nanomsg-ffi:+nn-req-resend-ivl+)
    ;; :sub socket options
    (:subscribe nanomsg-ffi:+nn-sub-subscribe+)
    (:unsubscribe nanomsg-ffi:+nn-sub-unsubscribe+)
    ;; :surveyor socket options
    (:surveyor-deadline nanomsg-ffi:+nn-surveyor-deadline+)
    ;; :tcp transport options
    (:tcp-nodelay nanomsg-ffi:+nn-tcp-nodelay+)
    (t -1)))

(defmacro sockopt-level-constant (level)
  (with-gensyms (result)
    `(let ((,result (when (eq :sol-socket ,level)
                      nanomsg-ffi:+nn-sol-socket+)))
       (unless ,result
         (setf ,result (protocol-constant ,level))
         (when (= ,result -1)
           (setf ,result (transport-constant ,level))))
       ,result)))

(defmacro with-sockopt-data ((v optval optval-length) &body forms)
  (etypecase v
    (string `(with-foreign-string (,optval ,v)
               (let ((,optval-length (length ,v)))
                 ,@forms)))
    (integer `(with-foreign-object (,optval :int64)
                (setf (mem-ref optval :int64) ,v)
                (let ((,optval-length (foreign-type-size :int64)))
                  ,@forms)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; API
;; Please refer to documentation.lisp for docstrings.

(defun errno ()
  (nn-errno))

(defun strerror (errnum)
  (multiple-value-bind (msg _) (nn-strerror errnum)
    (declare (ignore _))
    msg))

(defmacro make-socket (domain protocol)
  (with-gensyms (sock d p)
    `(let ((,d (domain-constant ,domain))
           (,p (protocol-constant ,protocol)))
       (when (= ,d -1)
         (error 'nanomsg-error :msg "Invalid socket domain specified."))
       (when (= ,p -1)
         (error 'nanomsg-error :msg "Invalid socket protocol specified."))
       (let ((,sock (nn-socket ,d ,p)))
         (unless (>= ,sock 0)
           (error 'nanomsg-error :msg (strerror (errno))))
         ,sock))))

(defmacro close-socket (socket)
  (with-gensyms (rc)
    `(let ((,rc (nn-close ,socket)))
       (unless (= 0 ,rc)
         (error 'nanomsg-error :msg (strerror (errno)))))))

(defmacro set-socket-option (socket level option value)
  (let ((val-type (etypecase value (string :string) (integer :int))))
    (with-gensyms (rc opt lev val len)
      `(autowrap:with-alloc (,val ,val-type)
         (setf (mem-ref ,val ,val-type) ,value)
         (let* ((,len ,(etypecase value (string (length value)) (integer (foreign-type-size :int))))
                (,opt (sockopt-constant ,option))
                (,lev (sockopt-level-constant ,level))
                (,rc (nn-setsockopt ,socket ,lev ,opt ,val ,len)))
           (unless (= ,rc 0)
             (error 'nanomsg-error :msg (strerror (errno)))))))))

(defmacro get-socket-option (socket level option val-type)
  (with-gensyms (rc opt lev val len)
    `(with-foreign-objects ((,val ,val-type)
                            (,len :int))
       (let* ((,opt (sockopt-constant ,option))
              (,lev (sockopt-level-constant ,level))
              (,rc (nn-getsockopt ,socket ,lev ,opt ,val ,len)))
         (unless (= ,rc 0)
           (error 'nanomsg-error :msg (strerror (errno))))
         (mem-ref ,val ,val-type)))))
