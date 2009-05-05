

;; Original version by Kyle McDonald:
;;
;; http://www.openprocessing.org/visuals/?visualID=1182
;;
;; Ported to Abstracting by Ed Cavazos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(for-each require-lib '("list" "math" "tendrils/nodebox"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *number-of-cells* 5000)

(define *base-line-length* 37)

(define *rotation-speed-step* 0.004)

(define *slow-down-rate* 0.97)

(set! *y-increases-up* #f)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (det x1 y1 x2 y2 x3 y3)
  (-   (* (- x2 x1)
          (- y3 y1))

       (* (- x3 x1)
          (- y2 y1))))

(define (cell x y)

  (let ((spin-velocity 0)
        (current-angle 0))

    (let ((sense
           (lambda ()
             
             (if (or (not (= *p-mouse-x* 0))
                     (not (= *p-mouse-y* 0)))
                 
                 (set! spin-velocity

                   (+ spin-velocity

                      (/ (* *rotation-speed-step*

                            (det x y *p-mouse-x* *p-mouse-y* *mouse-x* *mouse-y*))

                         (+ (dist x y *mouse-x* *mouse-y*) 1)))))

             (set! spin-velocity (* spin-velocity *slow-down-rate*))

             (set! current-angle (+ current-angle spin-velocity))

             (let ((d (+ 0.001 (* *base-line-length* spin-velocity))))

               (glVertex2d x y)
               (glVertex2d (+ x (* d (cos current-angle)))
                           (+ y (* d (sin current-angle))))))))

      (vector 'cell sense))))

(define (sense cell)
  ((vector-ref cell 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set! *title* "Empathy by Kyle McDonald")

(size 500 500)

;; (set! *frames-per-second* #t)

(set! *frames-per-second* 30)

(init-nodebox)

(stroke 0.0 0.0 0.0 0.5)

(define *cells*
  (list-tabulate *number-of-cells*
    (lambda (i)

      (let ((theta (+ i (random 0 (/ pi 9))))
            (dista (+ 3

                      (random -3 3)

                      (* (/ i *number-of-cells*)

                         (/ *width* 2)

                         (* (/ (- *number-of-cells* i) *number-of-cells*) 3.3)))))

        (cell (+   (/ *width*  2)   (* dista (cos theta)))
              (+   (/ *height* 2)   (* dista (sin theta))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set! *draw*

  (lambda ()

    (background 1.0)

    (glColor4d 0.0 0.0 0.0 0.5)

    (glBegin GL_LINES)
    (for-each sense *cells*)
    (glEnd)

    (set! *p-mouse-x* *mouse-x*)
    (set! *p-mouse-y* *mouse-y*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(run-nodebox)

      

                    

