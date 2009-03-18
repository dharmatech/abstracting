
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

               ((hue)        (lambda () hue))
               ((saturation) (lambda () saturation))
               ((value)      (lambda () value))
               ((alpha)      (lambda () alpha))

               ((hue!)        (lambda (new) (set! hue        new)))
               ((saturation!) (lambda (new) (set! saturation new)))
               ((value!)      (lambda (new) (set! value      new)))
               ((alpha!)      (lambda (new) (set! alpha      new)))

               ((clone) (hsva hue saturation value alpha))

               ((rgba) to-rgba)

               ((raw) (vector hue saturation value alpha))))))

      (vector 'hsva #f message-handler))))