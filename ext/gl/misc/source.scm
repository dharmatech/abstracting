
(define (gl-color       . args) (apply glColor4d    (map exact->inexact args)))

;; (define (gl-color r g b a)
;;   (glColor4d (inexact r)
;;              (inexact g)
;;              (inexact b)
;;              (inexact a)))

(define (gl-clear-color . args) (apply glClearColor (map exact->inexact args)))
(define (gl-ortho       . args) (apply glOrtho      (map exact->inexact args)))

