
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "xlib/ypsilon"))

  ((chicken) ((-> loader 'lib) "xlib/chicken"))

  ((larceny) ((-> loader 'lib) "xlib/larceny"))

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (x-query-tree-children dpy win)
  (list-ref (x-query-tree dpy win) 2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (x-query-pointer dpy win)

  (let ((root-return   (u32-vec 0))
        (child-return  (u32-vec 0))
        (root-x-return (s32-vec 0))
        (root-y-return (s32-vec 0))
        (win-x-return  (s32-vec 0))
        (win-y-return  (s32-vec 0))
        (mask-return   (u32-vec 0)))

    (XQueryPointer dpy win
                   (: root-return   'ffi)
                   (: child-return  'ffi)
                   (: root-x-return 'ffi)
                   (: root-y-return 'ffi)
                   (: win-x-return  'ffi)
                   (: win-y-return  'ffi)
                   (: mask-return   'ffi))

    (list (: root-return   'ref 0)
          (: child-return  'ref 0)
          (: root-x-return 'ref 0)
          (: root-y-return 'ref 0)
          (: win-x-return  'ref 0)
          (: win-y-return  'ref 0)
          (: mask-return   'ref 0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (x-query-pointer-root-x-y dpy win)
  (let ((result (x-query-pointer dpy win)))
    (list
     (list-ref result 2)
     (list-ref result 3))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

