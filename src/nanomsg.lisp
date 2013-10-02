(in-package #:nanomsg)

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

(defmacro sockopt-constant (option)
  (case option
    (t 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; api

(defun errno ()
  (nn-errno))

(defun strerror (errnum)
  (multiple-value-bind (msg _) (nn-strerror errnum)
    (declare (ignore _))
    msg))

(defmacro make-socket (domain protocol)
  "Creates an SP socket with specified domain and protocol. 
Returns a file descriptor for the newly created socket.

The following domains are defined at the moment:
:sp - Standard full-blown SP socket
:sp-raw - Raw SP socket.
          Raw sockets omit the end-to-end functionality found in :sp sockets 
          and thus can be used to implement intermediary devices in :sp topologies.

The protocol parameter defines the type of the socket, which in turn determines the 
exact semantics of the socket. 

The following protocols are defined at the moment:
:pub, :sub, :req, :rep, :pair, :surveyor, :respondent, :push, :pull, :bus

Please refer to the nanomsg documentation for details on each protocol type.

The newly created socket is initially not associated with any endpoints. 
In order to establish a message flow at least one endpoint has to be added to the socket 
using the nanomsg:bind or nanomsg:connect function.

Also note that type argument as found in standard socket(2) function is omitted from nn_socket. 
All the SP sockets are message-based and thus of SOCK_SEQPACKET type.

If the function succeeds the file descriptor of the new socket is returned. 
Otherwise a nanomsg-error condition is raised with an error message provided by nanomsg:strerror."
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
  "Closes the socket. Any buffered inbound messages that were not yet received by the 
application will be discarded. 
The library will try to deliver any outstanding outbound messages for the time specified 
by the :linger socket option. The call will block in the meantime."
  (with-gensyms (rc)
    `(let ((,rc (nn-close ,socket)))
       (unless (= 0 ,rc)
         (error 'nanomsg-error :msg (strerror (errno)))))))

(defun set-socket-options (socket level option value)
  (etypecase value
    (string (with-foreign-string (str value)
              (nn-setsockopt socket level option str (length value))))
    (integer (with-foreign-object (int :int64)
               (setf (mem-ref int :int64) value)
               (nn-setsockopt socket level option int (foreign-type-size :int64))))))



