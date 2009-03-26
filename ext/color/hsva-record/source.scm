
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define hsva-record-template
  (record-template-obj 'hsva '(hue saturation value alpha)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define hsva (-> hsva-record-template 'boa))

(define hsva-hue        (: hsva-record-template 'getter 'hue))
(define hsva-saturation (: hsva-record-template 'getter 'saturation))
(define hsva-value      (: hsva-record-template 'getter 'value))
(define hsva-alpha      (: hsva-record-template 'getter 'alpha))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (hsva->rgba color)

  (let ((hue        (inexact (hsva-hue        color)))
        (saturation (inexact (hsva-saturation color)))
        (value      (inexact (hsva-value      color)))
        (alpha      (inexact (hsva-alpha      color))))

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
            ((5) (rgba value p   q   alpha))))))))