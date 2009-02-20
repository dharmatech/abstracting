
;; (define (hsva hue saturation value alpha)

;;   (let ((Hi (lambda () (mod (inexact->exact (floor (/ hue 60))) 6))))

;;     (let ((f (lambda () (- (/ hue 60) (Hi))))
;; 	  (p (lambda () (* (- 1 saturation) value))))

;;       (let ((q (lambda () (* (- 1 (*      (f)  saturation)) value)))
;; 	    (t (lambda () (* (- 1 (* (- 1 (f)) saturation)) value))))

;; 	(let ((to-rgba
;; 	       (lambda ()
;; 		 (case (Hi)
;; 		   ((0) (rgba value (t)   (p)   alpha))
;; 		   ((1) (rgba (q)   value (p)   alpha))
;; 		   ((2) (rgba (p)   value (t)   alpha))
;; 		   ((3) (rgba (p)   (q)   value alpha))
;; 		   ((4) (rgba (t)   (p)   value alpha))
;; 		   ((5) (rgba value (p)   (q)   alpha))))))

;; 	  (let ((message-handler

;; 		 (lambda (msg)

;; 		   (case msg

;; 		     ((hue)        hue)
;; 		     ((saturation) saturation)
;; 		     ((value)      value)
;; 		     ((alpha)      alpha)

;; 		     ((hue!)        (lambda (new) (set! hue        new)))
;; 		     ((saturation!) (lambda (new) (set! saturation new)))
;; 		     ((value!)      (lambda (new) (set! value      new)))
;; 		     ((alpha!)      (lambda (new) (set! alpha      new)))

;; 		     ((clone) (hsva hue saturation value alpha))

;; 		     ((rgba) to-rgba)

;; 		     ((raw) (vector hue saturation value alpha))))))

;; 	    (vector 'hsva #f message-handler)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mixed flonums and fixnums

;; (define (hsva hue saturation value alpha)

;;   (let ((to-rgba
         
;;          (lambda ()

;;            (let ((Hi (mod (inexact->exact (floor (/ hue 60))) 6)))

;;              (let ((f (- (/ hue 60) Hi))
;;                    (p (* (- 1 saturation) value)))

;;                (let ((q (* (- 1 (*      f  saturation)) value))
;;                      (t (* (- 1 (* (- 1 f) saturation)) value)))
           
;;                  (case Hi
;;                    ((0) (rgba value t   p   alpha))
;;                    ((1) (rgba q   value p   alpha))
;;                    ((2) (rgba p   value t   alpha))
;;                    ((3) (rgba p   q   value alpha))
;;                    ((4) (rgba t   p   value alpha))
;;                    ((5) (rgba value p   q   alpha)))))))))

;;     (let ((message-handler

;;            (lambda (msg)

;;              (case msg

;;                ((hue)        hue)
;;                ((saturation) saturation)
;;                ((value)      value)
;;                ((alpha)      alpha)

;;                ((hue!)        (lambda (new) (set! hue        new)))
;;                ((saturation!) (lambda (new) (set! saturation new)))
;;                ((value!)      (lambda (new) (set! value      new)))
;;                ((alpha!)      (lambda (new) (set! alpha      new)))

;;                ((clone) (hsva hue saturation value alpha))

;;                ((rgba) to-rgba)

;;                ((raw) (vector hue saturation value alpha))))))

;;       (vector 'hsva #f message-handler))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; flonum arithmetic procedures

;; (import (rnrs arithmetic flonums))

;; (define (hsva hue saturation value alpha)

;;   (let ((to-rgba
         
;;          (lambda ()

;;            (let ((hue        (inexact hue))
;;                  (saturation (inexact saturation))
;;                  (value      (inexact value))
;;                  (alpha      (inexact alpha)))

;;              (let ((Hi (mod (flfloor (fl/ hue 60.0)) 6.0)))

;;                (let ((f (fl- (fl/ hue 60.0) Hi))
;;                      (p (fl* (fl- 1.0 saturation) value)))

;;                  (let ((q (fl* (fl- 1.0 (fl*      f  saturation)) value))
;;                        (t (fl* (fl- 1.0 (fl* (fl- 1.0 f) saturation)) value)))
                   
;;                    (case (exact Hi)
;;                      ((0) (rgba value t   p   alpha))
;;                      ((1) (rgba q   value p   alpha))
;;                      ((2) (rgba p   value t   alpha))
;;                      ((3) (rgba p   q   value alpha))
;;                      ((4) (rgba t   p   value alpha))
;;                      ((5) (rgba value p   q   alpha))))))))))

;;     (let ((message-handler

;;            (lambda (msg)

;;              (case msg

;;                ((hue)        hue)
;;                ((saturation) saturation)
;;                ((value)      value)
;;                ((alpha)      alpha)

;;                ((hue!)        (lambda (new) (set! hue        new)))
;;                ((saturation!) (lambda (new) (set! saturation new)))
;;                ((value!)      (lambda (new) (set! value      new)))
;;                ((alpha!)      (lambda (new) (set! alpha      new)))

;;                ((clone) (hsva hue saturation value alpha))

;;                ((rgba) to-rgba)

;;                ((raw) (vector hue saturation value alpha))))))

;;       (vector 'hsva #f message-handler))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Converted to flonums. Using generic arithmetic procedures.

(define (hsva hue saturation value alpha)

  (let ((to-rgba
         
         (lambda ()

           (let ((hue        (inexact hue))
                 (saturation (inexact saturation))
                 (value      (inexact value))
                 (alpha      (inexact alpha)))

             (let ((Hi (mod (floor (/ hue 60.0)) 6.0)))

               (let ((f (- (/ hue 60.0) Hi))
                     (p (* (- 1.0 saturation) value)))

                 (let ((q (* (- 1.0 (*      f  saturation)) value))
                       (t (* (- 1.0 (* (- 1.0 f) saturation)) value)))
                   
                   (case (exact Hi)
                     ((0) (rgba value t   p   alpha))
                     ((1) (rgba q   value p   alpha))
                     ((2) (rgba p   value t   alpha))
                     ((3) (rgba p   q   value alpha))
                     ((4) (rgba t   p   value alpha))
                     ((5) (rgba value p   q   alpha))))))))))

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((hue)        hue)
               ((saturation) saturation)
               ((value)      value)
               ((alpha)      alpha)

               ((hue!)        (lambda (new) (set! hue        new)))
               ((saturation!) (lambda (new) (set! saturation new)))
               ((value!)      (lambda (new) (set! value      new)))
               ((alpha!)      (lambda (new) (set! alpha      new)))

               ((clone) (hsva hue saturation value alpha))

               ((rgba) to-rgba)

               ((raw) (vector hue saturation value alpha))))))

      (vector 'hsva #f message-handler))))