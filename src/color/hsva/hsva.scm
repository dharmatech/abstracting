
(define (hsva hue saturation value alpha)

  (let ((Hi (lambda () (mod (inexact->exact (floor (/ hue 60))) 6))))

    (let ((f (lambda () (- (/ hue 60) (Hi))))
	  (p (lambda () (* (- 1 saturation) value))))

      (let ((q (lambda () (* (- 1 (*      (f)  saturation)) value)))
	    (t (lambda () (* (- 1 (* (- 1 (f)) saturation)) value))))

	(let ((to-rgba
	       (lambda ()
		 (case (Hi)
		   ((0) (rgba value (t)   (p)   alpha))
		   ((1) (rgba (q)   value (p)   alpha))
		   ((2) (rgba (p)   value (t)   alpha))
		   ((3) (rgba (p)   (q)   value alpha))
		   ((4) (rgba (t)   (p)   value alpha))
		   ((5) (rgba value (p)   (q)   alpha))))))

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

	    (vector 'hsva #f message-handler)))))))