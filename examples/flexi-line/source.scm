
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original version by Jill Jackson
;;
;; http://www.openprocessing.org/visuals/?visualID=323
;;
;; Ported to Abstracting by Ed Cavazos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(initialize-glut)

(glutInitDisplayMode GLUT_DOUBLE)
  
(basic-window "Flexi Line by Jill Jackson" (width 500) (height 500))

(mouse mouse-button mouse-state mouse-x mouse-y)

(frames-per-second 30)

(define make-point

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

(define (update-point p)
  ((vector-ref p 1)))

(define num 5000)

(define points
  (list-tabulate num
                 (lambda (i)
                   (make-point (inexact (* (/ i num) width))
                               (inexact (/ height 2))))))

(define (update-points)
  (for-each update-point points))

(buffered-display-procedure
 (lambda ()

   (background 0.0)

   (glColor4d 1.0 1.0 1.0 1.0)
   
   (glBegin GL_LINE_STRIP)
   (update-points)
   (glEnd) ))

(glutMainLoop)