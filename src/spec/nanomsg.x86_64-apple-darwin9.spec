[
{ "tag": "function", "name": "__errno_location", "location": "/usr/include/bits/errno.h:47:13", "variadic": false, "parameters": [], "return-type": { "tag": ":pointer", "type": { "tag": ":int" } } },
{ "tag": "typedef", "name": "ptrdiff_t", "location": "/usr/local/lib/clang/3.3/include/stddef.h:34:26", "type": { "tag": ":long" } },
{ "tag": "typedef", "name": "size_t", "location": "/usr/local/lib/clang/3.3/include/stddef.h:42:23", "type": { "tag": ":unsigned-long" } },
{ "tag": "typedef", "name": "wchar_t", "location": "/usr/local/lib/clang/3.3/include/stddef.h:51:24", "type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_errno", "location": "/usr/include/nanomsg/nn.h:208:15", "variadic": false, "parameters": [], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_strerror", "location": "/usr/include/nanomsg/nn.h:211:23", "variadic": false, "parameters": [{ "tag": "parameter", "name": "errnum", "type": { "tag": ":int" } }], "return-type": { "tag": ":pointer", "type": { "tag": ":char" } } },
{ "tag": "function", "name": "nn_symbol", "location": "/usr/include/nanomsg/nn.h:216:23", "variadic": false, "parameters": [{ "tag": "parameter", "name": "i", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "value", "type": { "tag": ":pointer", "type": { "tag": ":int" } } }], "return-type": { "tag": ":pointer", "type": { "tag": ":char" } } },
{ "tag": "function", "name": "nn_term", "location": "/usr/include/nanomsg/nn.h:222:16", "variadic": false, "parameters": [], "return-type": { "tag": ":void" } },
{ "tag": "function", "name": "nn_allocmsg", "location": "/usr/include/nanomsg/nn.h:230:17", "variadic": false, "parameters": [{ "tag": "parameter", "name": "size", "type": { "tag": "size_t" } }, { "tag": "parameter", "name": "type", "type": { "tag": ":int" } }], "return-type": { "tag": ":pointer", "type": { "tag": ":void" } } },
{ "tag": "function", "name": "nn_freemsg", "location": "/usr/include/nanomsg/nn.h:231:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "msg", "type": { "tag": ":pointer", "type": { "tag": ":void" } } }], "return-type": { "tag": ":int" } },
{ "tag": "struct", "name": "nn_iovec", "id": 0, "location": "/usr/include/nanomsg/nn.h:237:8", "bit-size": 128, "bit-alignment": 64, "fields": [{ "tag": "field", "name": "iov_base", "bit-offset": 0, "bit-size": 64, "bit-alignment": 64, "type": { "tag": ":pointer", "type": { "tag": ":void" } } }, { "tag": "field", "name": "iov_len", "bit-offset": 64, "bit-size": 64, "bit-alignment": 64, "type": { "tag": "size_t" } }] },
{ "tag": "struct", "name": "nn_msghdr", "id": 0, "location": "/usr/include/nanomsg/nn.h:242:8", "bit-size": 256, "bit-alignment": 64, "fields": [{ "tag": "field", "name": "msg_iov", "bit-offset": 0, "bit-size": 64, "bit-alignment": 64, "type": { "tag": ":pointer", "type": { "tag": ":struct", "name": "nn_iovec", "id": 0 } } }, { "tag": "field", "name": "msg_iovlen", "bit-offset": 64, "bit-size": 32, "bit-alignment": 32, "type": { "tag": ":int" } }, { "tag": "field", "name": "msg_control", "bit-offset": 128, "bit-size": 64, "bit-alignment": 64, "type": { "tag": ":pointer", "type": { "tag": ":void" } } }, { "tag": "field", "name": "msg_controllen", "bit-offset": 192, "bit-size": 64, "bit-alignment": 64, "type": { "tag": "size_t" } }] },
{ "tag": "struct", "name": "nn_cmsghdr", "id": 0, "location": "/usr/include/nanomsg/nn.h:249:8", "bit-size": 128, "bit-alignment": 64, "fields": [{ "tag": "field", "name": "cmsg_len", "bit-offset": 0, "bit-size": 64, "bit-alignment": 64, "type": { "tag": "size_t" } }, { "tag": "field", "name": "cmsg_level", "bit-offset": 64, "bit-size": 32, "bit-alignment": 32, "type": { "tag": ":int" } }, { "tag": "field", "name": "cmsg_type", "bit-offset": 96, "bit-size": 32, "bit-alignment": 32, "type": { "tag": ":int" } }] },
{ "tag": "function", "name": "nn_cmsg_nexthdr_", "location": "/usr/include/nanomsg/nn.h:257:30", "variadic": false, "parameters": [{ "tag": "parameter", "name": "mhdr", "type": { "tag": ":pointer", "type": { "tag": ":struct", "name": "nn_msghdr", "id": 0 } } }, { "tag": "parameter", "name": "cmsg", "type": { "tag": ":pointer", "type": { "tag": ":struct", "name": "nn_cmsghdr", "id": 0 } } }], "return-type": { "tag": ":pointer", "type": { "tag": ":struct", "name": "nn_cmsghdr", "id": 0 } } },
{ "tag": "function", "name": "nn_socket", "location": "/usr/include/nanomsg/nn.h:320:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "domain", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "protocol", "type": { "tag": ":int" } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_close", "location": "/usr/include/nanomsg/nn.h:321:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_setsockopt", "location": "/usr/include/nanomsg/nn.h:322:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "level", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "option", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "optval", "type": { "tag": ":pointer", "type": { "tag": ":void" } } }, { "tag": "parameter", "name": "optvallen", "type": { "tag": "size_t" } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_getsockopt", "location": "/usr/include/nanomsg/nn.h:324:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "level", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "option", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "optval", "type": { "tag": ":pointer", "type": { "tag": ":void" } } }, { "tag": "parameter", "name": "optvallen", "type": { "tag": ":pointer", "type": { "tag": "size_t" } } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_bind", "location": "/usr/include/nanomsg/nn.h:326:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "addr", "type": { "tag": ":pointer", "type": { "tag": ":char" } } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_connect", "location": "/usr/include/nanomsg/nn.h:327:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "addr", "type": { "tag": ":pointer", "type": { "tag": ":char" } } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_shutdown", "location": "/usr/include/nanomsg/nn.h:328:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "how", "type": { "tag": ":int" } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_send", "location": "/usr/include/nanomsg/nn.h:329:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "buf", "type": { "tag": ":pointer", "type": { "tag": ":void" } } }, { "tag": "parameter", "name": "len", "type": { "tag": "size_t" } }, { "tag": "parameter", "name": "flags", "type": { "tag": ":int" } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_recv", "location": "/usr/include/nanomsg/nn.h:330:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "buf", "type": { "tag": ":pointer", "type": { "tag": ":void" } } }, { "tag": "parameter", "name": "len", "type": { "tag": "size_t" } }, { "tag": "parameter", "name": "flags", "type": { "tag": ":int" } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_sendmsg", "location": "/usr/include/nanomsg/nn.h:331:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "msghdr", "type": { "tag": ":pointer", "type": { "tag": ":struct", "name": "nn_msghdr", "id": 0 } } }, { "tag": "parameter", "name": "flags", "type": { "tag": ":int" } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_recvmsg", "location": "/usr/include/nanomsg/nn.h:332:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "msghdr", "type": { "tag": ":pointer", "type": { "tag": ":struct", "name": "nn_msghdr", "id": 0 } } }, { "tag": "parameter", "name": "flags", "type": { "tag": ":int" } }], "return-type": { "tag": ":int" } },
{ "tag": "function", "name": "nn_device", "location": "/usr/include/nanomsg/nn.h:338:15", "variadic": false, "parameters": [{ "tag": "parameter", "name": "s1", "type": { "tag": ":int" } }, { "tag": "parameter", "name": "s2", "type": { "tag": ":int" } }], "return-type": { "tag": ":int" } }
]
