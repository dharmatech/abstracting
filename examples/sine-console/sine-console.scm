
;; http://processing.org/learning/trig

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "math")

((-> loader 'lib) "gl")

((-> loader 'lib) "glut")

((-> loader 'lib) "glo")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutInit (vector 0) (vector ""))

(glutInitDisplayMode GLUT_DOUBLE)

(glutInitWindowSize 350 150)

(glutCreateWindow "Sine Console")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutReshapeFunc
 (lambda (w h)
   (glEnable GL_BLEND)
   (glBlendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA)
   (glViewport 0 0 w h)
   (glMatrixMode GL_PROJECTION)
   (glLoadIdentity)
   (glOrtho 0.0 (exact->inexact w) 0.0 (exact->inexact h) -10.0 10.0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define wheel-x 75.0)
(define wheel-y 75.0)

(define wheel-radius 50)

(define time 0)

(define point-a (vec 0.0 0.0))
(define point-b (vec 0.0 0.0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (update-point-a)
  (set! point-a
        (vec (+ wheel-x (* wheel-radius (cos time)))
             (+ wheel-y (* wheel-radius (sin time))))))

(define (update-point-b)
  (set! point-b
        (vec (+ wheel-x wheel-radius (mod (* (/ time (* 2 pi))
                                             (* wheel-radius 4))
                                          (* wheel-radius 4)))
             (+ wheel-y (* wheel-radius (sin time))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define draw-wheel
  (let ((pen (pen)))
    (: pen 'no-stroke)
    (: pen 'set-fill-color white)
    (: pen 'move-to (vec wheel-x wheel-y))
    (lambda ()
      (: pen 'circle (* wheel-radius 2.0)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define node-pen (pen))

(: node-pen 'no-stroke)
(: node-pen 'set-fill-color black)

(define node-dim (vec 5 5))

(define (draw-node-a)
  (: node-pen 'rect point-a node-dim))

(define (draw-node-b)
  (: node-pen 'rect point-b node-dim))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define draw-node-connector
  (let ((pen (pen)))
    (: pen 'set-stroke-color (grey 0.19 1.0))
    (lambda ()
      (: pen 'line point-a point-b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define draw-radial
  (let ((pen (pen)))
    (: pen 'move-to (vec wheel-x wheel-y))
    (: pen 'set-stroke-color (grey 0.4 1.0))
    (lambda ()
      (: pen 'line-to point-a))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define draw-sine-curve
  (let ((pen (pen)))
    (: pen 'set-stroke-color (grey 0.78 1.0))
    (lambda ()
      (do ((i 0 (+ i 1)))
          ((= i 100))
        (let ((x (+ wheel-x wheel-radius (* (/ i 100.0) (* wheel-radius 4))))
              (y (+ wheel-y (* wheel-radius (sin (* (/ i 100.0) 2 pi))))))
          (: pen 'point (vec x y)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutDisplayFunc
 (lambda ()
   (glMatrixMode GL_MODELVIEW)
   (glLoadIdentity)
   (background (grey 0.5 1.0))
   (draw-wheel)
   (draw-sine-curve)
   (draw-node-a)
   (draw-node-b)
   (draw-node-connector)
   (draw-radial)
   (glutSwapBuffers)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutIdleFunc
 (lambda ()
   (set! time (+ time 0.01))
   (update-point-a)
   (update-point-b)
   (glutPostRedisplay)))

(glutMainLoop)