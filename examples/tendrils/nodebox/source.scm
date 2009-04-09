
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define random

  (case-lambda

   ((a b)

    (cond ((and (integer? a)
                (integer? b))

           (+ a (random-integer (- b a))))

          (else

           (+ a (* (- b a)
                   (random-real))))))

   ((a)

    (cond ((integer? a) (random 0 a))

          (else (random 0.0 a))))

   (() (random-real))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *width*  #f)
(define *height* #f)

(define (size w h)
  (set! *width*  w)
  (set! *height* w))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *fill-color*   (rgba 0.0 0.0 0.0 1.0))
(define *stroke-color* (rgba 1.0 1.0 1.0 1.0))

(define *stroke-width* 1.0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (no-fill)
  (set! *fill-color* (rgba 0.0 0.0 0.0 0.0)))

(define (no-stroke)
  (set! *stroke-color* (rgba 0.0 0.0 0.0 0.0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define background

  (case-lambda

   ((r g b a)
    (glClearColor r g b a)
    (glClear GL_COLOR_BUFFER_BIT))

   ((r g b) (background r g b 1.0))

   ((grey alpha) (background grey grey grey alpha))

   ((grey) (background grey grey grey 1.0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define stroke

  (case-lambda

   ((r g b a) (set! *stroke-color* (rgba r g b a)))
   ((r g b)   (set! *stroke-color* (rgba r g b 1.0)))
   ((g a)     (set! *stroke-color* (rgba g g g a)))
   ((g)       (set! *stroke-color* (rgba g g g 1.0)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *oval-quadric* #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define oval

  (case-lambda

   ((x y w h)

    (glPushMatrix)

    (glTranslated (+ x (/ w 2.0))
                  (+ y (/ h 2.0))
                  0.0)

    (glPushMatrix)
    (glScaled w h 0.0)
    (: *fill-color* 'apply glColor4d)
    (gluDisk *oval-quadric* 0.0 0.5 20 20)
    (glPopMatrix)

    (glPushMatrix)
    (glScaled (- w (* *stroke-width* 2.0))
              (- h (* *stroke-width* 2.0))
              0.0)
    (: *stroke-color* 'apply glColor4d)
    (gluDisk *oval-quadric* 0.4 0.5 20 20)
    (glPopMatrix)

    (glPopMatrix))

   ((pos dim)
    (oval (x pos) (y pos) (width dim) (height dim)))

   (() (oval 0.0 0.0 1.0 1.0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define circle

  (case-lambda

   ((x y d) (oval x y d d))

   ((pos dia) (oval (x pos) (y pos) dia dia))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define (init-nodebox)

;;   (glutInit (vector 0) (vector ""))

;;   (set! *oval-quadric* (gluNewQuadric))

;;   (random-source-randomize! default-random-source)

;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (init-nodebox)

  (glutInit (vector 0) (vector ""))

  (glutInitWindowSize *width* *height*)

  (glutCreateWindow "Abstracting")

  (glutReshapeFunc
   (lambda (w h)

     (set! *width*  w)
     (set! *height* h)

     (glEnable GL_POLYGON_SMOOTH)

     (glEnable GL_BLEND)
     (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
     (glViewport 0 0 w h)

     (glMatrixMode GL_PROJECTION)
     (glLoadIdentity)
     (glOrtho 0.0 (inexact w) 0.0 (inexact h) -10.0 10.0)))

  (set! *oval-quadric* (gluNewQuadric))

  (random-source-randomize! default-random-source)

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *draw* #f)

(define (run-nodebox)

  (glutDisplayFunc
   (lambda ()
     (glMatrixMode GL_MODELVIEW)
     (glLoadIdentity)
     (*draw*)))
  
  (glutMainLoop))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
