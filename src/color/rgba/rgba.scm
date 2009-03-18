
(define (rgba red green blue alpha)

  (let ((message-handler

	 (lambda (msg)

	   (case msg

	     ((red)   red)
	     ((green) green)
	     ((blue)  blue)
	     ((alpha) alpha)

             ((apply)
              (lambda (procedure)
		(procedure red green blue alpha)))

             ((clone)
              (lambda ()
                (rgba red green blue alpha)))
              
	     ((raw) (vector red green blue alpha))))))

    (vector 'rgba #f message-handler)))