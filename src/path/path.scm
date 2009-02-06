
(define (path name)

  (let ((absolute?
	 (lambda ()
	   (equal? #\/ (string-ref name 0)))))

    (let ((message-handler

	   (lambda (msg)

	     (case msg

	       ((absolute?) (absolute?))

	       ((absolute)
		(if (absolute?)
		    (path name)
		    (path (string-append (current-directory) "/" name))))

	       ((exists?) (file-exists? name))

	       ((show)
		(list 'path name))

	       ))))

      (vector 'path #f message-handler))))