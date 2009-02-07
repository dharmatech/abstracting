
(define (gl-color       . args) (apply glColor4d    (map exact->inexact args)))
(define (gl-clear-color . args) (apply glClearColor (map exact->inexact args)))
(define (gl-ortho       . args) (apply glOrtho      (map exact->inexact args)))

