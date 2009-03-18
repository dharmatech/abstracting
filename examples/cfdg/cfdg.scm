
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

((-> loader 'lib) "gro")

((-> loader 'lib) "math")

((-> loader 'lib) "glo")

((-> loader 'lib) "gl/misc")

((-> loader 'lib) "color/hsva")

((-> loader 'lib) "random-weighted")

((-> loader 'lib) "double-vector")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (get-modelview-matrix)
  (let ((bv (make-bytevector (* 16 8))))
    (glGetDoublev GL_MODELVIEW_MATRIX bv)
    bv))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (gl-flip angle)

  (let ((angle (/ (* angle pi) 180)))

    (let ((dv (double-vector (cos (* 2 angle))    (sin (* 2 angle))  0 0
                             (sin (* 2 angle)) (- (cos (* 2 angle))) 0 0
                             0                 0                     1 0
                             0                 0                     0 1)))

      (glMultMatrixd (-> dv 'raw)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (cfdg-model . body-expressions)

  `(let (
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;; The language
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         (background  #f)
         (threshold   #f)
         (viewport    #f)
         (start-shape #f)

         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         (x      #f)
         (y      #f)
         (size   #f)
         (rotate #f)
         (flip   #f)

         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         (hue        #f)
         (saturation #f)
         (brightness #f)
         (alpha      #f)

         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         (circle   #f)
         (square   #f)
         (triangle #f)

         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         (block    #f)
         (iterate? #f)

         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;; Not part of the language
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         
         (color-stack (gro-obj 100))

         (modelview-matrix-stack #f)

         )

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; Install transform commands
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

     (set! x      (lambda (x)     (glTranslated x 0.0 0.0)))
     (set! y      (lambda (y)     (glTranslated 0.0 y 0.0)))
     (set! size   (lambda (scale) (glScaled scale scale 1.0)))
     (set! rotate (lambda (angle) (glRotated (+ 0.0 angle) 0.0 0.0 1.0)))
     (set! flip   (lambda (angle) (gl-flip angle)))

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; Install commands which depend on color
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

     (let ((color (hsva 0.0 0.0 0.0 1.0)))

       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;; Install hue saturation brightness alpha
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       (let (($hue        (lambda () (-> color 'hue)))
             ($saturation (lambda () (-> color 'saturation)))
             ($value      (lambda () (-> color 'value)))
             ($alpha      (lambda () (-> color 'alpha)))

             (hue!        (lambda (new) ((-> color 'hue!)        new)))
             (saturation! (lambda (new) ((-> color 'saturation!) new)))
             (value!      (lambda (new) ((-> color 'value!)      new)))
             (alpha!      (lambda (new) ((-> color 'alpha!)      new)))

             (adjust
              (lambda (val num)
                (if (> num 0.0)
                    (+ val (* (- 1.0 val) num))
                    (+ val (*        val  num))))))

         (set! hue (lambda (num) (hue! (mod (+ ($hue) num) 360))))

         (set! saturation (lambda (num) (saturation! (adjust ($saturation) num))))
         (set! brightness (lambda (num) (value!      (adjust ($value)      num))))
         (set! alpha      (lambda (num) (alpha!      (adjust ($alpha)      num)))))

       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;; Install circle square triangle
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       (set! circle
             (lambda ()
               ((-> ((-> color 'rgba)) 'apply) glColor4d)
               (glutSolidSphere 0.5 32 16)))

       (set! square
             (lambda ()
               ((-> ((-> color 'rgba)) 'apply) gl-color)
               (glBegin GL_POLYGON)
               (glVertex2d -0.5  0.5)
               (glVertex2d  0.5  0.5)
               (glVertex2d  0.5 -0.5)
               (glVertex2d -0.5 -0.5)
               (glEnd)))

       (set! triangle
             (lambda ()
               ((-> ((-> color 'rgba)) 'apply) gl-color)
               (glBegin GL_POLYGON)
               (glVertex2d  0.0  0.577)
               (glVertex2d  0.5 -0.289)
               (glVertex2d -0.5 -0.289)
               (glEnd)))

       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;; Install block
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       (let ((push-modelview-matrix
              (lambda ()
                ((-> modelview-matrix-stack 'suffix)
                 (get-modelview-matrix))))

             (pop-modelview-matrix
              (lambda ()
                (let ((mat (-> modelview-matrix-stack 'pop)))
                  (glLoadMatrixd mat))))

             (push-color
              (lambda ()
                ((-> color-stack 'suffix)
                 (-> color 'clone))))

             (pop-color
              (lambda ()
                (set! color (-> color-stack 'pop)))))

         (set! block
               (lambda (procedure)
                 (push-modelview-matrix)
                 (push-color)
                 (procedure)
                 (pop-modelview-matrix)
                 (pop-color))))

       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;; Install iterate?
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       (set! iterate?
             (lambda ()
               (let ((ref (-> (double-vector-obj (get-modelview-matrix)) 'ref)))
                 (let ((size (apply max
                                    (map (lambda (i) (abs (ref i))) '(0 1 4 5)))))
                   ;; (display "iterate?: size is ") (display size) (newline)
                   (> size threshold)))))

       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       ;; Tell GLUT what the display function is
       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       (glutDisplayFunc

        (let ((display-list (glGenLists 1)))

          (let ((build-display-list
                 (lambda ()
                   (set! *display-list-generated* #t)
                   (glNewList display-list GL_COMPILE_AND_EXECUTE)
                   (set! color (hsva 0.0 0.0 0.0 1.0))
                   ((-> ((-> color 'rgba)) 'apply) gl-color)
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

                  (gl-ortho min-x max-x min-y max-y -10 10)))

              (glMatrixMode GL_MODELVIEW)

              (glLoadIdentity)

              ;; Set background color

              (set! color (hsva 0.0 0.0 1.0 1.0))

              (background)

              ((-> ((-> color 'rgba)) 'apply) gl-clear-color)

              (glClear GL_COLOR_BUFFER_BIT)

              ;; Initialize modelview matrix stack

              (set! modelview-matrix-stack (gro-obj 100))

              ;; Initialize color stack

              (set! color-stack (gro-obj 100))

              (if *display-list-generated*
                  (glCallList display-list)
                  
                  (time (build-display-list)))))))

       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       (let ()
         
         ,@body-expressions))))