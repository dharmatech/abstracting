

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (ensure-non-zero v) (v+ v (vec 0.001 0.001)))

(define (normalize* v)
  (normalize
   (ensure-non-zero v)))

;; (define normalize* (compose normalize ensure-non-zero))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (constrain n a b) (min (max n a) b))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (angle-between a b)
  (rad->deg
   (acos
    (constrain (/ (v. a b)
                  (* (norm a)
                     (norm b)))
               -1 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define <boid> (record-template-obj 'boid (vec 'pos 'vel)))

(define boid (-> <boid> 'boa))

(define boid-pos ((-> <boid> 'getter) 'pos))
(define boid-vel ((-> <boid> 'getter) 'vel))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (distance a b)
  (norm
   (v- (boid-pos a)
       (boid-pos b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (relative-position a b) (v- (boid-pos b) (boid-pos a)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (relative-angle a b)
  (angle-between (relative-position a b)
                 (boid-vel a)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (in-radius? self other radius)
  (<= (distance self other) radius))

(define (in-view? self other angle)
  (<= (relative-angle self other)
      (/ angle 2.0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vsum vecs)
  (let ((accum (vec 0 0)))
    ((-> vecs 'each)
     (lambda (v)
       (set! accum (v+ accum v))))
    accum))

(define (vaverage vecs)
  (v/n (vsum vecs)
       (: vecs 'len)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (average-position boids) (vaverage ((-> boids 'map) boid-pos)))
(define (average-velocity boids) (vaverage ((-> boids 'map) boid-vel)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define <behaviour>
  (record-template-obj 'behaviour (vec 'weight 'view-angle 'radius 'type)))

(define behaviour (-> <behaviour> 'boa))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (within-neighborhood? self other behaviour)
  (and
   (not (eq? self other))
   (in-radius? self other (get behaviour 'radius))
   (in-view?   self other (get behaviour 'view-angle))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (neighborhood self others behaviour)
  ((-> others 'filter)
   (lambda (other)
     (within-neighborhood? self other behaviour))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (cohesion-force self others behaviour)
  (v*n
   (normalize*
    (v- (average-position others)
        (get self 'pos)))
   (get behaviour 'weight)))

(define (alignment-force self others behaviour)
  (v*n
   (normalize*
    (average-velocity others))
   (get behaviour 'weight)))

(define (separation-force self others behaviour)
  (v*n
   (normalize*
    (v- (get self 'pos)
        (average-position others)))
   (get behaviour 'weight)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (force* self others behaviour)
  (case (get behaviour 'type)
    ((cohesion)   (cohesion-force   self others behaviour))
    ((alignment)  (alignment-force  self others behaviour))
    ((separation) (separation-force self others behaviour))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (force self others behaviour)

  (let ((result (neighborhood self others behaviour)))

    (if (-> result 'empty?)
        (vec 0 0)
        (force* self result behaviour))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (random-boids count)
  ((-> (vec-of-len count) 'map)
   (lambda (elt)
     (boid (vec (inexact (random-integer 500))
                (inexact (random-integer 500)))
           (ensure-non-zero
            (vec (inexact (+ -10 (random-integer 20)))
                 (inexact (+ -10 (random-integer 20)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (draw-boid boid)
  (glColor4d 1.0 1.0 1.0 1.0)
  (let ((a (get boid 'pos)))
    (let ((b (v+ a (v*n (normalize (get boid 'vel)) 10))))
      (glBegin GL_LINES)
      ((-> a 'apply) glVertex2d)
      ((-> b 'apply) glVertex2d)
      (glEnd))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define sky (vec 500.0 500.0))

(define boids #f)

(define behaviours #f)

(define time-slice #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (wrap pos dim)

  (let ((x (: pos 'first))
        (y (: pos 'second))

        (w (: dim 'first))
        (h (: dim 'second)))

    (vec (cond ((> x w) 0.0) ((< x 0.0) w) (else x))
         (cond ((> y h) 0.0) ((< y 0.0) h) (else y)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (iterate-system)

  (set! boids
        ((-> boids 'map)
         (lambda (self)


           (let ((forces ((-> behaviours 'map)
                          (lambda (behaviour)
                            (force self boids behaviour)))))

             (let ((accel (vsum forces)))

               (let ((pos (v+ (get self 'pos) (v*n (get self 'vel) time-slice)))
                     (vel (v+ (get self 'vel) (v*n accel          time-slice))))

                 (let ((pos (wrap pos sky))
                       (vel (normalize* vel)))

                   (boid pos vel)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set! boids (random-boids 50))

;; (set! time-slice 1.0)

(set! time-slice 10.0)

(set! behaviours (vec (behaviour 1.0 180.0 75.0 'cohesion)
                      (behaviour 1.0 180.0 50.0 'alignment)
                      (behaviour 1.0 180.0 25.0 'separation)))

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

   ((-> boids 'each) draw-boid)

   (glutSwapBuffers)))

(glutIdleFunc
 (lambda ()
   (iterate-system)
   (glutPostRedisplay)))

(glutMainLoop)