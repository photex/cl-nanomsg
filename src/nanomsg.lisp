(in-package #:nanomsg)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CFFI schtuff

(cffi:defcvar "errno" :int64)

(cffi:defcfun ("memcpy" memcpy) :pointer
  (dst :pointer)
  (src :pointer)
  (len :long))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; utils

(defun domain-constant (domain)
  (case domain
    (:sp nanomsg-ffi:+af-sp+)
    (:sp-raw nanomsg-ffi:+af-sp-raw+)
    (t -1)))

(defun protocol-constant (protocol)
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

(defun transport-constant (transport)
  (case transport
    (:tcp nanomsg-ffi:+nn-tcp+)
    (:inproc nanomsg-ffi:+nn-inproc+)
    (:ipc nanomsg-ffi:+nn-ipc+)
    (t -1)))

(defun sockopt-constant (option)
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

(defun sockopt-type (option)
  (case option
    (:subscribe :string)
    (:unsubscribe :string)
    (t :int)))

(defun sockopt-level-constant (level)
  (with-gensyms (result)
    `(let ((,result (case ,level
                      (:sol-socket nanomsg-ffi:+nn-sol-socket+)
                      (:domain nanomsg-ffi:+nn-domain+)
                      (:protocol nanomsg-ffi:+nn-protocol+)
                      (t -1))))
       (when (= ,result -1)
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
;; constants

(defconstant +sockaddrmax+ nanomsg-ffi:+nn-sockaddr-max+)
(defconstant +eagain+ nanomsg-ffi:+eagain+)
;; NN_MSG == ((size_t) -1)
;; It's used by recv at least to not limit the size of the msg buffer and
;; gets you a void* to the data as it comes instead of requiring a copy
(let ((bit-size (* 8 (cffi:foreign-type-size :pointer))))
  (defconstant +msg-max-len+ (1- (dpb 1 (byte bit-size bit-size) 0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; conditions

(define-condition nanomsg-error (error)
  ((err-msg :initarg :msg :initform nil :accessor err-msg))
  (:report (lambda (c s)
             (with-slots (err-msg) c
               (format s "NANOMSG Error: ~A" err-msg)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; API
;; Please refer to documentation.lisp for docstrings.

(defun errno ()
  (nn-errno))

(defun strerror (errnum)
  (multiple-value-bind (msg _) (nn-strerror errnum)
    (declare (ignore _))
    (format nil "(~A) ~a" errnum msg)))

(defmacro term ()
  `(nn-term))

(defun make-socket (domain protocol)
  (let ((d (domain-constant domain))
        (p (protocol-constant protocol)))
    (when (= d -1)
      (error 'nanomsg-error :msg "Invalid socket domain specified."))
    (when (= p -1)
      (error 'nanomsg-error :msg "Invalid socket protocol specified."))
    (let ((sock (nn-socket d p)))
      (unless (>= sock 0)
        (error 'nanomsg-error :msg (strerror (errno))))
      sock)))

(defun close-socket (socket)
  (let ((rc (nn-close socket)))
    (unless (= 0 rc)
      (error 'nanomsg-error :msg (strerror (errno))))))

(defmacro with-sockopt-alloc ((value vname vtype) &body forms)
  (case vtype
    (:string `(with-foreign-string (,vname ,value) ,@forms))
    (t `(autowrap:with-alloc (,vname ,vtype)
          (setf (mem-ref ,vname ,vtype) ,value)
          ,@forms))))

(defmacro set-socket-option (socket level option value)
  (let* ((val-type (sockopt-type option)))
    (with-gensyms (rc opt lev val len)
      (with-sockopt-alloc (value val val-type)
        (setf (mem-ref val val-type) value)
        (let* ((len (case val-type
                      (:string (length value))
                      (:int (foreign-type-size :int))))
               (opt (sockopt-constant option))
               (lev (sockopt-level-constant level))
               (rc (nn-setsockopt socket lev opt val len)))
          (unless (= rc 0)
            (error 'nanomsg-error :msg (strerror (errno)))))))))

(defun get-socket-option (socket level option)
  (let ((val-type (sockopt-type option)))
    (with-foreign-objects ((val val-type)
                           (len :int))
      ;; TODO until the ability to get string options is implemented
      ;; in nanomsg itself, we can't really test that aspect of this macro.
      ;; So far, it appears that integer options are working.
      ;; Unless I'm mistaken, the only string option you could query
      ;; is :subscribe and getting options for the :sub protocol
      ;; isn't implemented as of 0.2-alpha.
      (when (eq val-type :string)
        (setf (mem-ref len :int) 255))
      (let* ((opt (sockopt-constant option))
             (lev (sockopt-level-constant level))
             (rc (nn-getsockopt socket lev opt val len)))
        (unless (= rc 0)
          (error 'nanomsg-error :msg (strerror (errno))))
        (mem-ref val val-type)))))

(defmacro %config-endpoint (type socket addr)
  "Calls either bind, connect, or shutdown for a socket and address/endpoint.
If the type is :shutdown, addr should be an endpoint id (ie the result of a 
previous bind or connect) otherwise it should be an endpoint address (for example:
\"tcp://eth0:1234\")."
  (with-gensyms (eid)
    `(let ((,eid ,(case type
                     (:local `(nn-bind ,socket ,addr))
                     (:remote `(nn-connect ,socket ,addr))
                     (:shutdown `(nn-shutdown ,socket ,addr)))))
       (when (< ,eid 0)
         (error 'nanomsg-error :msg (strerror (errno))))
       ,eid)))

(defun bind (socket addr)
  (%config-endpoint :local socket addr))

(defun connect (socket addr)
  (%config-endpoint :remote socket addr))

(defun shutdown (socket eid)
  (%config-endpoint :shutdown socket eid))

(defun alloc-msg ()
  (let ((msg (nn-allocmsg 0 0)))
    (when (null-pointer-p msg)
      (error 'nanomsg-error :msg (strerror (errno))))
    msg))

(defun free-msg (msg)
  (let ((rc (nn-freemsg msg)))
    (when (< rc 0)
      (error 'nanomsg-error :msg (strerror (errno))))
    rc))

(defun send (socket msg &key dontwait)
  (let* ((flags (if dontwait 1 0))
         (bytes-sent (nn-send socket (autowrap:ptr msg) +msg-max-len+ flags)))
    ;; If bytes-sent == -1 and errno != +eagain+ we raise the error.
    ;; We return nil when non-blocking mode is requested
    ;; and the message couldn't be sent yet.
    ;; Otherwise we return the number of bytes sent.
    (if (< bytes-sent 0)
        (let ((errnum (errno)))
          (unless (and dontwait (= errnum +eagain+))
            (error 'nanomsg-error :msg (strerror errnum))))
        bytes-sent)))

(defun recv (socket buf &key dontwait)
  (let ((flags (if dontwait 1 0)))
    (let ((bytes-recv (nn-recv socket (autowrap:ptr buf) +msg-max-len+ flags)))
      (if (< bytes-recv 0)
          ;; Return nil or raise the error
          (let ((errnum (errno)))
            (unless (= errnum +eagain+)
              (error 'nanomsg-error :msg (strerror errnum))))
          (mem-ref buf :string)))))

(defun %test-echo (protocol address)
  (let* ((socket (make-socket :sp protocol))
         (eid (bind socket address))
         (buf (alloc-msg)))
    (format t "Attempting to listen using ~a on ~a.~%" protocol address)
    (unwind-protect
         (let ((msg (recv socket buf)))
           (format t "Received '~a'~%" msg)
           (send socket buf :dontwait t))
      (progn
        (shutdown socket eid)
        (close-socket socket)
        (free-msg buf)))))
