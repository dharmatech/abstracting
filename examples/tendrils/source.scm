
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Original version in NodeBox:
;; 
;; http://www.nodebox.net/code/index.php/Tendrils

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tendril pos width)

  (let ((angle (- (random (* 2 pi)) pi))
        (v 0)
        (segments '()))

    (let ((grow
           (lambda (distance curl step)

             (set! pos (pt+ pos (pt (* (cos angle) distance)
                                    (* (sin angle) distance))))

             (set! v (+ v (random (- step) step)))

             (set! v (* v (+ 0.9 (* curl 0.1))))

             (set! angle (+ angle v))

             (set! segments (cons pos segments))))

          (draw
           (let ((draw-segment
                  (lambda (fraction position)
                    (let ((diameter (inexact (* fraction width))))
                      (circle position diameter)))))
             (lambda ()
               (for-each-with-fraction draw-segment segments))))
          )

      (vector 'tendril grow draw))))

(define (tendril-grow tendril distance curl step)
  ((vector-ref tendril 1) distance curl step))

(define (tendril-draw tendril)
  ((vector-ref tendril 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (plant pos tendrils width)

  (let ((tendrils (map (lambda (i)
                         (tendril pos width))
                       (iota tendrils))))

    (let ((grow
           (lambda (distance curl step)
             (for-each (cut tendril-grow <> distance curl step) tendrils)))

          (draw
           (lambda ()
             (for-each tendril-draw tendrils))))

      (vector 'plant grow draw))))

(define (plant-grow plant distance curl step)
  ((vector-ref plant 1) distance curl step))

(define (plant-draw plant)
  ((vector-ref plant 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(size 600 600)

(init-nodebox)

(set! *draw*
      (lambda ()
        (background 0.12 0.12 0.06)
        (no-fill)
        (stroke 1 0.5)
        (set! *stroke-width* 0.5)
        (let ((plant (plant (pt (/ *width* 2) (/ *height* 2)) 20 15)))
          (do-times 200 (lambda (i)
                          (plant-grow plant 3.0 1.0 0.02)))
          (plant-draw plant))))

(run-nodebox)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

