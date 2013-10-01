;;;; nanomsg.asd

(asdf:defsystem #:nanomsg
  :description "Generally non-fancy bindings for nanomsg"
  :author "Chip Collier <photex@lofidelitygames.com>"
  :license "MIT"

  :depends-on (:cl-autowrap)
  :pathname "src"
  :serial t

  :components
  ((:module autowrap-spec
    :pathname "spec"
    :components
    ((:static-file "nanomsg.h")))
   (:file "package")
   (:file "library")
   (:file "autowrap")
   (:file "nanomsg")))
