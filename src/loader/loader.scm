
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (string-index-from-end-start-at string char i)
  
  (cond

   ((< i 0) #f)

   ((equal? (string-ref string i) char) i)

   (else
    (string-index-from-end-start-at string char (- i 1)))))

(define (string-index-from-end string char)
  (string-index-from-end-start-at string char (- (string-length string) 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-loader)

  (let ((roots (vec)))

    (let ((message-handler

	   (lambda (msg)

	     (case msg

	       ((add-root)
		(lambda (path)
		  (set! roots ((-> roots 'suffix) path))))
	       
	       ((lib)
		(lambda (name)

		  (let ((lib-base-name
			 (let ((i (string-index-from-end name #\/)))
			   (if i
			       (substring name (+ i 1) (string-length name))
			       name))))
		  
		  (let ((relative-lib-file
                         (string-append name "/" lib-base-name ".scm"))

                        (relative-lib-file-short
                         (string-append name "/" lib-base-name)))

		    (let ((root ((-> roots 'find)
				 (lambda (root)
				   (-> (path (string-append root
							    "/"
							    relative-lib-file))
				       'exists?)))))
		      (if root
			  ;; (load (string-append root "/" relative-lib-file))
                          (load (string-append root "/" relative-lib-file-short))
			  #f))))))

	       ))))

      (vector 'loader #f message-handler))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
