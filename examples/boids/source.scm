
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (boid pos vel) (vector 'boid pos vel))

(define pos (vector-nth 1))
(define vel (vector-nth 2))

(define pos! (set-vector-nth! 1))
(define vel! (set-vector-nth! 2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (ensure-non-zero p)
  (pt+ p '#(pt 0.001 0.001)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (normalize* p)
  (normalize
   (ensure-non-zero p)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (constrain n a b)
  (min (max n a) b))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (angle-between a b)
  (rad->deg
   (acos
    (constrain (/ (dot a b)
                  (* (norm a)
                     (norm b)))
               -1 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (distance a b)
  (norm (pt- (pos a) (pos b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (relative-position a b)
  (pt- (pos b) (pos a)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (relative-angle a b)
  (angle-between (relative-position a b)
                 (vel a)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (pt-sum seq)
  (: seq 'reduce pt+ '#(pt 0 0)))

(define (pt-average seq)
  (pt/n (pt-sum seq)
        (: seq 'len)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (average-position boids) (pt-average (: boids 'map pos)))
(define (average-velocity boids) (pt-average (: boids 'map vel)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (cohesion self others)
  (if (: others 'empty?)
      '#(0 0)
      (pt- (average-position others)
          (pos self))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (alignment self others)
  (if (: others 'empty?)
      '#(0 0)
      (average-velocity others)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (separation self others)
  (if (: others 'empty?)
      '#(0 0)
      (pt- (pos self)
          (average-position others))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (behaviour weight view-angle radius react)

  (let ((force
         (lambda (self others)

           (let ((neighborhood

                  (let ((within-neighborhood?
                         (lambda (other)

                           (let ((in-radius?
                                  (lambda ()
                                    (<= (distance self other) radius)))

                                 (in-view?
                                  (lambda ()
                                    (<= (relative-angle self other)
                                        (/ view-angle 2.0)))))
                             
                             (and (not (eq? other self))
                                  (in-radius?)
                                  (in-view?))))))
                    
                    (: others 'filter within-neighborhood?))))

             (if (: neighborhood 'empty?)
                 '#(pt 0 0)
                 (pt*n (react self neighborhood) weight))

             ))))

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((force) force)

               ))))

      (vector 'behaviour #f message-handler))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (random-boids count)
  (: (vec-of-len count) 'map
     (lambda (elt)
       (boid (pt (inexact (random-integer 500))
                 (inexact (random-integer 500)))
             (ensure-non-zero
              (pt (inexact (+ -10 (random-integer 20)))
                  (inexact (+ -10 (random-integer 20)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (pt-angle p)
  (rad->deg (atan (y p) (x p))))

;; (define pt-angle (bi point-y point-x (uni atan rad->deg)))

(define (draw-boid boid)

  (let ((draw-triangle
         (lambda ()
           (glBegin GL_POLYGON)
           (glVertex2i 0   5)
           (glVertex2i 0  -5)
           (glVertex2i 20  0)
           (glEnd))))

    (glPushMatrix)

    (glTranslated (x (pos boid)) (y (pos boid)) 0.0)

    (glRotated (pt-angle (vel boid)) 0.0 0.0 1.0)

    (glPolygonMode GL_FRONT_AND_BACK GL_LINE)
    (glColor4d 1.0 1.0 1.0 0.5)
    (draw-triangle)

    (glPolygonMode GL_FRONT_AND_BACK GL_FILL)
    (glColor4d 1.0 0.0 0.0 0.5)
    (draw-triangle)

    (glPopMatrix)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define sky (pt 500.0 500.0))

(define boids #f)

(define behaviours #f)

(define time-slice #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define width  (vector-nth 1))
(define height (vector-nth 2))

(define (wrap pos dim)

  (let ((x (x pos))
        (y (y pos))

        (w (width  dim))
        (h (height dim)))

    (pt (cond ((> x w) 0.0) ((< x 0.0) w) (else x))
        (cond ((> y h) 0.0) ((< y 0.0) h) (else y)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (iterate-system)

  (set! boids
        (: boids 'map
           (lambda (self)

             (let ((forces
                    (: behaviours 'map
                       (lambda (behaviour)
                         (: behaviour 'force self boids)))))

               (let ((accel (: forces 'reduce pt+ (pt 0 0))))

                 (let ((pos (pt+ (pos self) (pt*n (vel self) time-slice)))
                       (vel (pt+ (vel self) (pt*n  accel      time-slice))))

                   (let ((pos (wrap pos sky))
                         (vel (normalize* vel)))

                   (boid pos vel)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set! boids (random-boids 50))

(set! time-slice 10.0)

(set! behaviours (lis (behaviour 1.0 180.0 75.0 cohesion)
                      (behaviour 1.0 180.0 50.0 alignment)
                      (behaviour 1.0 180.0 25.0 separation)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutInitDisplayMode GLUT_DOUBLE)

(glutInit (vector 0) (vector ""))

(glutInitWindowPosition 100 100)

(glutInitWindowSize 500 500)

(glutCreateWindow "Boids")

(glutReshapeFunc
 (lambda (w h)
   (glEnable GL_BLEND)
   (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
   (glViewport 0 0 w h)

   (glMatrixMode GL_PROJECTION)
   (glLoadIdentity)
   (glOrtho 0.0 (inexact w) 0.0 (inexact h) -10.0 10.0)))

(glutDisplayFunc
 (lambda ()

   (glMatrixMode GL_MODELVIEW)

   (glLoadIdentity)

   (glClearColor 0.0 0.0 0.0 0.0)

   (glClear GL_COLOR_BUFFER_BIT)

   (: boids 'each draw-boid)

   (glutSwapBuffers)))

(glutIdleFunc
 (lambda ()
   (iterate-system)
   (glutPostRedisplay)))

(glutMainLoop)