
(define (char c)

  (let ((message-handler

	 (lambda (msg)

	   (case msg

	     ((=) (lambda (x) (char=? c x)))))))

    (vector 'char c message-handler)))