
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "xlib/ypsilon"))

  ((chicken) ((-> loader 'lib) "xlib/chicken"))

  ((larceny) ((-> loader 'lib) "xlib/larceny"))

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (x-query-tree-children dpy win)
  (list-ref (x-query-tree dpy win) 2))

