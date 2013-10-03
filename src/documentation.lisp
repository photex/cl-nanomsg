(in-package #:nanomsg)

(setf (documentation 'make-socket 'function)
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
Otherwise a nanomsg-error condition is raised with an error message provided by nanomsg:strerror.")

(setf (documentation 'close-socket 'function)
      "Closes the socket. Any buffered inbound messages that were not yet received by the 
application will be discarded. The library will try to deliver any outstanding outbound 
messages for the time specified by the :linger socket option. The call will block in the meantime.

If the function fails a nanomsg-error condition is raised with an error message provided by nanomsg:strerror.")

(setf (documentation 'set-socket-option 'function)
      "Sets the value of the option. The level argument specifies the protocol level at which 
the option resides. For generic socket-level options use :sol-socket level. 
For socket-type-specific options use socket type for level argument (e.g. :sub). 
For transport-specific options use ID of the transport as the level argument (e.g. :tcp).

The new value is pointed to by optval argument. Size of the option is specified by the optvallen argument.

The options for the :sol-socket level are as follows:
:linger - Specifies how long should the socket try to send pending outbound 
          messages after nanomsg:close-socket has been called, in milliseconds. 
          Negative value means infinite linger. 
          The type of the option is int. Default value is 1000 (1 second).

:sndbuf - Size of the send buffer, in bytes. To prevent blocking for messages larger 
          than the buffer, exactly one message may be buffered in addition to the data 
          in the send buffer. 
          The type of this option is int. Default value is 128kB.

:rcvbuf - Size of the receive buffer, in bytes. To prevent blocking for messages larger 
          than the buffer, exactly one message may be buffered in addition to the data 
          in the receive buffer. 
          The type of this option is int. Default value is 128kB.

:sndtimeo - The timeout for send operation on the socket, in milliseconds. If message 
            cannot be sent within the specified timeout, :eagain error is returned. 
            Negative value means infinite timeout. 
            The type of the option is int. Default value is -1.

:rcvtimeo - The timeout for recv operation on the socket, in milliseconds. If message 
            cannot be received within the specified timeout, :eagain error is returned. 
            Negative value means infinite timeout. 
            The type of the option is int. Default value is -1.

:reconnect-ivl - For connection-based transports such as TCP, this option specifies how 
                 long to wait, in milliseconds, when connection is broken before trying 
                 to re-establish it. Note that actual reconnect interval may be randomised 
                 to some extent to prevent severe reconnection storms. 
                 The type of the option is int. Default value is 100 (0.1 second).

:reconnect-ivl-max - This option is to be used only in addition to :reconnect-ivl option. 
                     It specifies maximum reconnection interval. On each reconnect attempt, 
                     the previous interval is doubled until :reconnect-ivl-max is reached. 
                     Value of zero means that no exponential backoff is performed and 
                     reconnect interval is based only on :reconnect-ivl. 
                     If :reconnect-ivl-max is less than :reconnect-ivl, it is ignored. 
                     The type of the option is int. Default value is 0.

:sndprio - Sets outbound priority for endpoints subsequently added to the socket. This 
           option has no effect on socket types that send messages to all the peers. 
           However, if the socket type sends each message to a single peer (or a limited 
           set of peers), peers with high priority take precedence over peers with low 
           priority. 
           The type of the option is int. Highest priority is 1, lowest priority is 16. 
           Default value is 8.

:ipv4only - If set to 1, only IPv4 addresses are used. If set to 0, both IPv4 and IPv6 
            addresses are used. 
            The type of the option is int. Default value is 1.

The options for the :tcp level are as follows:
:tcp-nodelay - This option, when set to 1, disables Nagle’s algorithm. It also disables 
               delaying of TCP acknowledgments. Using this option improves latency at 
               the expense of throughput. 
               Type of this option is int. Default value is 0.

The options for the :req socket level are as follows:
:req-resend-ivl - This option is defined on the full REQ socket. If reply is not received 
                  in specified amount of milliseconds, the request will be automatically 
                  resent. 
                  The type of this option is int. Default value is 60000 (1 minute).

The options for the :sub socket level are as follows:
:subscribe - Defined on full SUB socket. Subscribes for a particular topic. 
             Type of the option is string.
:unsubscribe - Defined on full SUB socket. Unsubscribes from a particular topic. 
               Type of the option is string.

The options for the :surveyor socket level are as follows:
:surveyor-deadline - Specifies how long to wait for responses to the survey. Once the deadline 
                     expires, receive function will return ETIMEDOUT error and all subsequent 
                     responses to the survey will be silently dropped. The deadline is measured 
                     in milliseconds. 
                     Option type is int. Default value is 1000 (1 second).

If the function succeeds then 0 is returned. Otherwise -1 is returned and the error code
can be retrieved with nanomsg:errno. nanomsg:strerror can convert the error number into
a human readable message.")
