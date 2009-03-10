
(import (xlib))

;; Kludge till Ypsilon accepts '#f' for char*.

(define _XOpenDisplay XOpenDisplay)

(define (XOpenDisplay name)
  (_XOpenDisplay (if (eq? name #f)
                     0
                     name)))
