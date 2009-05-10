
;; Original version by Jill Jackson
;;
;; http://www.openprocessing.org/visuals/?visualID=323
;;
;; Ported to Abstracting by Ed Cavazos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(initialize-glut)

(let (

      (width  500)
      (height 500)

      (mouse-button 0)
      (mouse-state  GLUT_UP)
      (mouse-x      0)
      (mouse-y      0)

      )

  (glutInitDisplayMode GLUT_DOUBLE)

  (glutInitWindowSize width height)

  (glutCreateWindow "Flexi Line by Jill Jackson")

  (glutPassiveMotionFunc
   (lambda (x y)
     (set! mouse-x x)
     (set! mouse-y y)))

  (glutMouseFunc
   (lambda (button state x y)
     (set! mouse-button button)
     (set! mouse-state  state)
     (set! mouse-x      x)
     (set! mouse-y      y)))

  (frames-per-second 30)

  (glutReshapeFunc
   (lambda (w h)

     (glViewport 0 0 w h)

     (glMatrixMode GL_PROJECTION)

     (glLoadIdentity)

     (glOrtho 0.0 (inexact w) (inexact h) 0.0 -1000.0 1000.0)
     
     (set! width  w)
     (set! height h)))
       
  (let ((update-points

         (let ((points

                (let ((make-point
                       
                       (let ((pow 1))
                         
                         (lambda (x y)
                           
                           (let ((dx 0)
                                 (dy 0))

                             (let ((update
                                    (lambda ()

                                      ;; accelerate

                                      (if (= mouse-state GLUT_DOWN)
                                          (let ((k (* pow
                                                      pow
                                                      (if (= mouse-button
                                                             GLUT_LEFT_BUTTON)
                                                          1
                                                          -1)))
                                                
                                                (ang (atan (- mouse-y y)
                                                           (- mouse-x x))))

                                            (set! dx (+ dx (* k (cos ang))))
                                            (set! dy (+ dy (* k (sin ang))))))

                                      ;; move

                                      (set! dx (* dx 0.98))
                                      (set! dy (* dy 0.98))

                                      (set! x (+ x dx))
                                      (set! y (+ y dy))

                                      ;; draw

                                      (glVertex2d x y))))

                               (vector 'point update))))))
                      
                      (num 5000))

                  (list-tabulate num
                                 (lambda (i)
                                   (make-point (* (inexact (/ i num)) width)
                                               (inexact (/ height 2)))))))

               (update-point
                (lambda (p)
                  ((vector-ref p 1)))))

           (lambda ()
             (for-each update-point points)))))

    (glutDisplayFunc
     (lambda ()
     
       (glMatrixMode GL_MODELVIEW)
       (glLoadIdentity)

       (glClearColor 0.0 0.0 0.0 0.0)

       (glClear GL_COLOR_BUFFER_BIT)

       (glColor4d 1.0 1.0 1.0 1.0)
       (glBegin GL_LINE_STRIP)
       (update-points)
       (glEnd)

       (glutSwapBuffers)))))

(glutMainLoop)