
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "glo")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *mouse-position* (vec 0.0 0.0))

(define (passive-motion-func x y)
  (set! *mouse-position* (vec (+ x 0.0) (+ y 0.0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *points*
  (circular-obj
   ((-> (vec-of-len 100) 'map)
    (lambda (elt)
      (vec 0.0 0.0)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (idle-func)
  ((-> *points* 'suffix) *mouse-position*)
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

	 (glClearColor 0.0 0.0 0.0 0.0)

	 (glClear GL_COLOR_BUFFER_BIT)

	 ((-> *points* 'each-index)
	  (lambda (i)
	    (move-to ((-> *points* 'ref) i))
	    (let ((fraction (/ i (-> *points* 'len))))
	      (circle (max (* fraction 25) 5.0)))))

	 (glutSwapBuffers))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutPassiveMotionFunc passive-motion-func)
(glutIdleFunc          idle-func)

(glutMainLoop)
