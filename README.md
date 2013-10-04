cl-nanomsg
==========

A Common Lisp wrapper for the nanomsg library (http://nanomsg.org).
Built using cl-autowrap (http://github.com/rpav/cl-autowrap).


This is early stuff
-------------------

This code might be too rough around the edges for anyone. But if you're up for helping, any and all contributions are very welcome.


Quickstart
----------

*From the REPL*

    (ql:quickload :nanomsg)
    (nanomsg::%test-echo :rep "tcp://127.0.0.1:1234")

*From the shell*

    nanocat --req -A -l 1234 -D "Hello echo test."
