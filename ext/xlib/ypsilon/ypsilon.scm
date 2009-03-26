
(import (xlib))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Kludge till Ypsilon accepts '#f' for char*.

(define _XOpenDisplay XOpenDisplay)

(define (XOpenDisplay name)
  (_XOpenDisplay (if (eq? name #f)
                     0
                     name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import (ypsilon c-types))

(define (x-query-tree dpy win)

  (let ((root-return      (make-bytevector 4))
        (parent-return    (make-bytevector 4))
        (children-return  (make-bytevector sizeof:void*))
        (nchildren-return (make-bytevector 4)))

    (XQueryTree dpy
                win
                root-return
                parent-return
                children-return
                nchildren-return)

    (let ((root          (bytevector-u32-native-ref root-return      0))
          (parent        (bytevector-u32-native-ref parent-return    0))
          (children-addr (bytevector-c-void*-ref    children-return  0))
          (nchildren     (bytevector-u32-native-ref nchildren-return 0)))

      (let ((children-bv
             (make-bytevector-mapping children-addr (* nchildren 4)))
            (children (make-vector nchildren)))
    
        (let loop ((i 0))

          (cond ((>= i nchildren)
                 (XFree children-addr)
                 children)
                (else
                 (vector-set! children i
                              (bytevector-u32-native-ref children-bv (* i 4)))
                      (loop (+ i 1)))))

        (list root parent children)))))