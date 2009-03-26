
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (get-modelview-matrix)
  (let ((hv (f64-vec-of-len 16)))
    (glGetDoublev GL_MODELVIEW_MATRIX (: hv 'ffi))
    hv))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (gl-flip angle)

  (let ((angle (/ (* angle pi) 180)))

    (let ((hv (f64-vec (cos (* 2 angle))    (sin (* 2 angle))  0.0 0.0
                       (sin (* 2 angle)) (- (cos (* 2 angle))) 0.0 0.0
                       0.0                 0.0                 1.0 0.0
                       0.0                 0.0                 0.0 1.0)))

      (glMultMatrixd (: hv 'ffi)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (change record field procedure)
  (set record field (procedure (get record field))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *background*  #f)
(define *threshold*   #f)
(define *viewport*    #f)
(define *start-shape* #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Transform commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (x      amt)   (glTranslated amt 0.0 0.0))
(define (y      amt)   (glTranslated 0.0 amt 0.0))
(define (size   scale) (glScaled scale scale 1.0))
(define (rotate angle) (glRotated (+ 0.0 angle) 0.0 0.0 1.0))
(define (flip   angle) (gl-flip angle))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The state variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *color*                  #f)
(define *color-stack*            #f)
(define *modelview-matrix-stack* #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (adjust num)
  (lambda (val)
    (if (> num 0.0)
        (+ val (* (- 1.0 val) num))
        (+ val (*        val  num)))))

(define (hue num) (change *color* 'hue (lambda (old) (mod (+ old num) 360))))

(define (saturation num) (change *color* 'saturation (adjust num)))
(define (brightness num) (change *color* 'value      (adjust num)))
(define (alpha      num) (change *color* 'alpha      (adjust num)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (circle)
  (: (hsva->rgba *color*) 'apply glColor4d)
  (glutSolidSphere 0.5 32 16))

(define (square)
  (: (hsva->rgba *color*) 'apply glColor4d)
  (glBegin GL_POLYGON)
  (glVertex2d -0.5  0.5)
  (glVertex2d  0.5  0.5)
  (glVertex2d  0.5 -0.5)
  (glVertex2d -0.5 -0.5)
  (glEnd))

(define (triangle)
  (: (hsva->rgba *color*) 'apply glColor4d)
  (glBegin GL_POLYGON)
  (glVertex2d  0.0  0.577)
  (glVertex2d  0.5 -0.289)
  (glVertex2d -0.5 -0.289)
  (glEnd))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define block

  (let ((push-modelview-matrix
         (lambda ()
           ((-> *modelview-matrix-stack* 'suffix)
            (get-modelview-matrix))))

        (pop-modelview-matrix
         (lambda ()
           (let ((mat (-> *modelview-matrix-stack* 'pop)))
             (glLoadMatrixd (: mat 'ffi)))))

        (push-color
         (lambda ()
           ((-> *color-stack* 'suffix)
            (: *color* 'apply hsva))))

        (pop-color
         (lambda ()
           (set! *color* (-> *color-stack* 'pop)))))

    (lambda (procedure)
      (push-modelview-matrix)
      (push-color)
      (procedure)
      (pop-modelview-matrix)
      (pop-color))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (iterate?)
  (let ((ref (-> (get-modelview-matrix) 'ref)))
    (let ((size (apply max
                       (map (lambda (i) (abs (ref i))) '(0 1 4 5)))))
      (> size *threshold*))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *display-list-generated* #f)

(define (install-display-func)
  
  (glutDisplayFunc

   (let ((display-list (glGenLists 1)))

     (let ((build-display-list
            (lambda ()
              (set! *display-list-generated* #t)
              (glNewList display-list GL_COMPILE_AND_EXECUTE)
              (set! *color* (hsva 0.0 0.0 0.0 1.0))
              ;; ((-> ((-> *color* 'rgba)) 'apply) gl-color)

              (: (hsva->rgba *color*) 'apply glColor4d)
              
              (*start-shape*)
              (glEndList))))

       (lambda ()

         (glMatrixMode GL_PROJECTION)

         (glLoadIdentity)

         (let ((min-x  (: *viewport* 'first))
               (width  (: *viewport* 'second))
               (min-y  (: *viewport* 'third))
               (height (: *viewport* 'fourth)))

           (let ((max-x (+ min-x width))
                 (max-y (+ min-y height)))

             (gl-ortho min-x max-x min-y max-y -10 10)))

         (glMatrixMode GL_MODELVIEW)

         (glLoadIdentity)

         ;; Set background color

         (set! *color* (hsva 0.0 0.0 1.0 1.0))

         (*background*)

         ;; ((-> ((-> *color* 'rgba)) 'apply) gl-clear-color)
         
         (: (hsva->rgba *color*) 'apply gl-clear-color)
         
         (glClear GL_COLOR_BUFFER_BIT)

         ;; Initialize modelview matrix stack

         (set! *modelview-matrix-stack* (gro-obj 100))

         ;; Initialize color stack

         (set! *color-stack* (gro-obj 100))

         (if *display-list-generated*
             (glCallList display-list)
             
             (time (build-display-list))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

