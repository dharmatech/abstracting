
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (str-obj s)

  (let ((len (string-length s))
	(ref (lambda (i) (string-ref s i)))
	(set (lambda (i elt) (string-set! s i elt))))

    (let ((first-index 0)
	  (last-index (- len 1)))

      (let ((before-beginning? (lambda (i) (< i first-index)))
	    (after-end?        (lambda (i) (> i last-index))))

	(let ((index-start-at
	       (lambda (pred i past? step)
		 (let loop ((i i))
		   (cond
		    ((past? i) #f)
		    ((pred (ref i)) i)
		    (else (loop (step i 1))))))))

	  (let ((index-forward-start-at
		 (lambda (pred i)
		   (index-start-at pred i after-end? +)))

		(index-backward-start-at
		 (lambda (pred i)
		   (index-start-at pred i before-beginning? -))))

	    (let ((index-forward
		   (lambda (pred)
		     (index-forward-start-at pred first-index)))

		  (index-backward
		   (lambda (pred)
		     (index-backward-start-at pred last-index))))

	      (let ((message-handler

		     (lambda (msg)

		       (case msg

			 ((len) len)
			 ((ref) ref)
			 ((set) set)

			 ((index-forward)  index-forward)
			 ((index-backward) index-backward)

			 ;;

			 ((raw) s)

			 ))))
		
      (vector 'str s message-handler)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

