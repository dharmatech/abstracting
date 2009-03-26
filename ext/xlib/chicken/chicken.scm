
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(chicken-scheme-load
 (string-append abstracting-root-directory
                "/support/chicken/xlib/xlib.so"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (x-query-tree dpy win)

  (let ((root-return      (u32vector 0))
        (parent-return    (u32vector 0))
        (children-return  (allocate sizeof:c-pointer))
        (nchildren-return (u32vector 0)))

    (XQueryTree dpy
                win
                root-return
                parent-return
                children-return
                nchildren-return)

    (let ((root      (u32vector-ref       root-return      0))
          (parent    (u32vector-ref       parent-return    0))
          (children* (pointer-pointer-ref children-return   ))
          (nchildren (u32vector-ref       nchildren-return 0)))

      (let ((children (make-vector nchildren)))
    
        (let loop ((i 0))

          (cond ((>= i nchildren)
                 (XFree children*)
                 children)
                (else (vector-set! children i
                                   (pointer-u32-ref
                                    (pointer-offset children* (* i 4))))
                      (loop (+ i 1)))))

        (list root parent children)))))