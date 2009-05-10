
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

(define (dist x1 y1 x2 y2)
  (sqrt (+ (sq (- x2 x1))
           (sq (- y2 y1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (processing-map value low1 high1 low2 high2)
  (+ low2
     (* (/ (- value low1)
           (- high1 low1))
        (- high2 low2))))

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

(define fill

  (case-lambda

   ((r g b a) (set! *fill-color* (rgba r g b a)))
   ((r g b)   (set! *fill-color* (rgba r g b 1.0)))
   ((g a)     (set! *fill-color* (rgba g g g a)))
   ((g)       (set! *fill-color* (rgba g g g 1.0)))))

(define stroke

  (case-lambda

   ((r g b a) (set! *stroke-color* (rgba r g b a)))
   ((r g b)   (set! *stroke-color* (rgba r g b 1.0)))
   ((g a)     (set! *stroke-color* (rgba g g g a)))
   ((g)       (set! *stroke-color* (rgba g g g 1.0)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define line

  (case-lambda

   ((x1 y1 x2 y2)
    (: *stroke-color* 'apply glColor4d)
    (glBegin GL_LINES)
    (glVertex2d x1 y1)
    (glVertex2d x2 y2)
    (glEnd))

   ((a b)
    (line (x a) (y a) (x b) (y b)))))

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

    ;; (glPushMatrix)
    ;; (glScaled w h 0.0)
    ;; (: *fill-color* 'apply glColor4d)
    ;; (gluDisk *oval-quadric* 0.0 0.5 20 20)
    ;; (glPopMatrix)

    ;; (glPushMatrix)
    ;; (glScaled (- w (* *stroke-width* 2.0))
    ;;           (- h (* *stroke-width* 2.0))
    ;;           0.0)
    ;; (: *stroke-color* 'apply glColor4d)
    ;; (gluDisk *oval-quadric* 0.4 0.5 20 20)
    ;; (gluDisk *oval-quadric* 0.4 0.5 20 20)
    ;; (glPopMatrix)

    (glPushMatrix)
    (glScaled w h 0.0)
    
    (: *fill-color* 'apply glColor4d)
    (gluDisk *oval-quadric* 0.0 0.5 50 50)
    
    (: *stroke-color* 'apply glColor4d)

    (gluDisk *oval-quadric*
             (- 0.5 (* *stroke-width* 0.5))
             0.5 50 50)
    
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

(define *p-mouse-x* 0)
(define *p-mouse-y* 0)

(define *mouse-x* 0)
(define *mouse-y* 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *title* #f)

(define *y-increases-up* #t)

(define (init-nodebox)

  (glutInit (vector 0) (vector ""))

  (glutInitDisplayMode GLUT_DOUBLE)

  (glutInitWindowSize *width* *height*)

  ;; (glutCreateWindow "Abstracting")

  (glutCreateWindow (if *title* *title* "Abstracting"))

  (glutReshapeFunc
   (lambda (w h)

     (set! *width*  w)
     (set! *height* h)

     (glEnable GL_POINT_SMOOTH)
     (glEnable GL_LINE_SMOOTH)
     (glEnable GL_POLYGON_SMOOTH)

     (glEnable GL_BLEND)
     (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
     (glViewport 0 0 w h)

     (if *y-increases-up*
         (begin
           (glMatrixMode GL_PROJECTION)
           (glLoadIdentity)
           (glOrtho 0.0 (inexact w) 0.0 (inexact h) -1000.0 1000.0))
         (begin
           (glMatrixMode GL_PROJECTION)
           (glLoadIdentity)
           (glOrtho 0.0 (inexact w) (inexact h) 0.0 -1000.0 1000.0)))))

  (glutPassiveMotionFunc
   (lambda (x y)

     (set! *p-mouse-x* *mouse-x*)
     (set! *p-mouse-y* *mouse-y*)
     
     (set! *mouse-x* x)
     (set! *mouse-y* y)))

  (set! *oval-quadric* (gluNewQuadric))

  (random-source-randomize! default-random-source)

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *draw* #f)

(define *frames-per-second* #f)

(define *last-display-time* 0)

(define (nanoseconds-since-last-display)
  (- (current-time-in-nanoseconds)
     *last-display-time*))

(define (nanoseconds-per-frame)
  (/ 1000000000.0 *frames-per-second*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *mouse-pressed* #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (run-nodebox)

  (glutDisplayFunc
   (lambda ()
     (glMatrixMode GL_MODELVIEW)
     (glLoadIdentity)
     (*draw*)
     (glutSwapBuffers)
     ))

  
     

  ;; (if *frames-per-second*
  ;;     (glutIdleFunc
  ;;      (lambda ()
  ;;        (glutPostRedisplay))))

  (cond ((eq? *frames-per-second* #t)
         (glutIdleFunc
          (lambda ()
            (glutPostRedisplay))))
        ((number? *frames-per-second*)
         (glutIdleFunc
          (lambda ()
            (if (> (nanoseconds-since-last-display)
                   (nanoseconds-per-frame))
                (begin
                  (set! *last-display-time* (current-time-in-nanoseconds))
                  (glutPostRedisplay)))))))
  
  (glutMainLoop))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (initialize-glut)
  (glutInit (vector 0) (vector "")))

(define (frames-per-second n)

  (let ((last-display-time 0))

    (let ((nanoseconds-per-frame
           (lambda ()
             (/ 1000000000.0 n)))

          (nanoseconds-since-last-display
           (lambda ()
             (- (current-time-in-nanoseconds)
                last-display-time))))

      (glutIdleFunc
       (lambda ()
         (if (> (nanoseconds-since-last-display)
                (nanoseconds-per-frame))
             (begin
               (set! last-display-time (current-time-in-nanoseconds))
               (glutPostRedisplay))))))))