
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "gro")

((-> loader 'lib) "math")

((-> loader 'lib) "glo")

((-> loader 'lib) "gl/misc")

((-> loader 'lib) "color/hsva")

((-> loader 'lib) "random-weighted")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (get-modelview-matrix)
  (let ((bytevector
	 (let ((size-of-GLdouble-in-bytes 8)
	       (number-of-elements 16))
	   (make-bytevector
	    (* number-of-elements size-of-GLdouble-in-bytes)))))
    (glGetDoublev GL_MODELVIEW_MATRIX bytevector)
    bytevector))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (double-vector-obj bv)

  (let ((message-handler

	 (lambda (msg)

	   (case msg

	     ((ref)
	      (lambda (i)
		(bytevector-ieee-double-native-ref bv (* i 8))))

	     ((raw) bv)

	     ))))

    (vector 'double-vector #f message-handler)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (cfdg-model . body-expressions)

  `(let (

         (color (hsva 0 0 0 1))

         (color-stack (gro-obj 100))

         (background #f)

         (threshold #f)

         (viewport #f)

         (start-shape #f)

         (adjust
          (lambda (val num)
            (if (> num 0)
                (+ val (* (- 1 val) num))
                (+ val (*      val  num)))))

         (modelview-matrix-stack #f)

         )

     (let (
           (hue        (lambda () (-> color 'hue)))
           (saturation (lambda () (-> color 'saturation)))
           (value      (lambda () (-> color 'value)))
           (alpha      (lambda () (-> color 'alpha)))

           (hue!        (lambda (new) ((-> color 'hue!) new)))
           (saturation! (lambda (new) ((-> color 'saturation!) new)))
           (value!      (lambda (new) ((-> color 'value!) new)))
           (alpha!      (lambda (new) ((-> color 'alpha!) new)))

           (push-modelview-matrix
            (lambda ()
              ((-> modelview-matrix-stack 'suffix)
               (get-modelview-matrix))))

           (pop-modelview-matrix
            (lambda ()
              (let ((mat (-> modelview-matrix-stack 'pop)))
                (glLoadMatrixd mat))))

           )

       (let (

             (hue (lambda (num) (hue! (mod (+ (hue) num) 360))))
             
             (saturation (lambda (num) (saturation! (adjust (saturation) num))))
             (brightness (lambda (num) (value!      (adjust (value)      num))))
             (alpha      (lambda (num) (alpha!      (adjust (alpha)      num))))

             (push-color
              (lambda ()
                ((-> color-stack 'suffix)
                 (-> color 'clone))))

             (pop-color
              (lambda ()
                (set! color (-> color-stack 'pop))))

             (iterate?
              (lambda ()
                (let ((ref (-> (double-vector-obj (get-modelview-matrix)) 'ref)))
                  (let ((size (apply max
                                     (map (lambda (i) (abs (ref i))) '(0 1 4 5)))))
                    (display "iterate?: size is ") (display size) (newline)
                    (> size threshold)))))

             (circle
              (lambda ()
                ((-> ((-> color 'rgba)) 'call-on-components) gl-color)
                (glutSolidSphere 0.5 32 16)))

             )

         (let (

               (x    (lambda (x) (glTranslated x 0.0 0.0)))

               (y    (lambda (y) (glTranslated 0.0 y 0.0)))

               (size (lambda (scale) (glScaled scale scale 1.0)))

               (rotate (lambda (angle) (glRotated (+ 0.0 angle) 0.0 0.0 1.0)))
               
               (block
                (lambda (procedure)
                  (push-modelview-matrix)
                  (push-color)
                  (procedure)
                  (pop-modelview-matrix)
                  (pop-color)))

               )

           (let ((display-function

                  (let ((display-list (glGenLists 1)))

                    (let ((build-display-list
                           
                           (lambda ()

                             (set! *display-list-generated* #t)
                             
                             (glNewList display-list GL_COMPILE_AND_EXECUTE)

                             ;; set-initial-color

                             (set! color (hsva 0 0 0 1))

                             ((-> ((-> color 'rgba)) 'call-on-components) gl-color)
                             
                             (start-shape)

                             (glEndList))))

                      (lambda ()

                        (glMatrixMode GL_PROJECTION)

                        (glLoadIdentity)

                        (let ((min-x  (-> viewport 'first))
                              (width  (-> viewport 'second))
                              (min-y  (-> viewport 'third))
                              (height (-> viewport 'fourth)))

                          (let ((max-x (+ min-x width))
                                (max-y (+ min-y height)))

                            (gl-ortho min-x max-x min-y max-y -10 10)

                            ))

                        (glMatrixMode GL_MODELVIEW)

                        (glLoadIdentity)

                        ;; set-background ...

                        (set! color (hsva 0 0 1 1))

                        (background)

                        ((-> ((-> color 'rgba)) 'call-on-components) gl-clear-color)

                        (glClear GL_COLOR_BUFFER_BIT)

                        ;; init-modelview-matrix-stack ...

                        (set! modelview-matrix-stack (gro-obj 100))

                        ;; init-color-stack

                        (set! color-stack (gro-obj 100))

                        (if *display-list-generated*
                            (glCallList display-list)
                            (build-display-list)))))))

             (glutDisplayFunc display-function))

           (let ()

             ,@body-expressions))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

