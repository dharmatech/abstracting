
(define (rgba red green blue alpha)

  (let ((message-handler

	 (lambda (msg)

	   (case msg

	     ((red)   (lambda () red))
	     ((green) (lambda () green))
	     ((blue)  (lambda () blue))
	     ((alpha) (lambda () alpha))

             ((red!)   (lambda (new) (set! red    new)))
             ((green!) (lambda (new) (set! green  new)))
             ((blue!)  (lambda (new) (set! blue   new)))
             ((alpha!) (lambda (new) (set! alpha  new)))

             ((apply)
              (lambda (procedure)
		(procedure red green blue alpha)))

             ((clone)
              (lambda ()
                (rgba red green blue alpha)))))))
              
    (vector 'rgba #f message-handler)))