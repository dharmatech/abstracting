
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "srfi/1")

((-> loader 'lib) "glo")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (at-least min)
  (lambda (n)
    (max min n)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *mouse-position* (vec 0.0 0.0))

(define (passive-motion-func x y)
  (set! *mouse-position* (vec (inexact x) (inexact y))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *length* 100)

(define *points*
  (apply circular-list
         (map (lambda (x) (vec 0.0 0.0))
              (make-list *length*))))

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

	 (glClearColor 0.0 0.0 0.0 0.0)

	 (glClear GL_COLOR_BUFFER_BIT)

         (let loop ((i 0) (cell *points*))

           (cond ((= i *length*)
                  #t)

                 (else

                  (move-to (car cell))

                  (let ((fraction (/ i *length*)))
                    (let ((max-radius 25.0)
                          (min-radius  5.0))
                      (let ((radius ((at-least min-radius)
                                     (* fraction max-radius))))
                        (circle radius))))

                  (loop (+ i 1) (cdr cell)))))

	 (glutSwapBuffers))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(glutPassiveMotionFunc passive-motion-func)
(glutIdleFunc          idle-func)

(glutMainLoop)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

