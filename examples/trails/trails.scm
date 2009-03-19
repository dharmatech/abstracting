
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "srfi/1")

((-> loader 'lib) "circular-list")

((-> loader 'lib) "glo")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *mouse-position* (vec 0.0 0.0))

(define (passive-motion-func x y)
  (set! *mouse-position* (vec (inexact x) (inexact y))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *length* 100)

(define *points*
  (circular-list-tabulate *length*
                          (lambda (i)
                            (vec 0.0 0.0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (idle-func)
  (set-car! *points* *mouse-position*)
  (set! *points* (cdr *points*))
  (glutPostRedisplay))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutInitDisplayMode GLUT_DOUBLE)

(glutInitWindowPosition 100 100)
(glutInitWindowSize 500 500)

(glutInit (vector 0) (vector ""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(let ((win (create-window "Trails")))

  (-> win 'ortho-standard)

  ((-> win 'display-function)

   (let ((pen (pen)))

     ((-> pen 'set-stroke-color) (rgba 0.0 0.0 0.0 0.0)) ; no stroke
     
     ((-> pen 'set-fill-color) (rgba 1.0 1.0 1.0 0.1)) ; White with transparency

     (let ((move-to (-> pen 'move-to))
	   (circle  (-> pen 'circle)))

       (lambda ()

         (background black)

         (circular-list-each-index
          (lambda (i point)
            (move-to point)
            (let ((fraction (/ i *length*)))
              (circle (max 5.0 (* fraction 25.0)))))
          *points*)

	 (glutSwapBuffers))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutPassiveMotionFunc passive-motion-func)
(glutIdleFunc          idle-func)

(glutMainLoop)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

