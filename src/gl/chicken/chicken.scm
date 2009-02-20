
(use gl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define _glGetDoublev glGetDoublev)

(define (glGetDoublev val bv)
  (_glGetDoublev val (blob->f64vector/shared bv)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define _glLoadMatrixd glLoadMatrixd)

(define (glLoadMatrixd bv)
  (_glLoadMatrixd (blob->f64vector/shared bv)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define _glMultMatrixd glMultMatrixd)

(define (glMultMatrixd bv)
  (_glMultMatrixd (blob->f64vector/shared bv)))