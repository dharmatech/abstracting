
(define (gro-obj underlying-size)

  (let ((underlying (vec-of-len underlying-size))
	(size 0))

    (let ((message-handler

	   (lambda (msg)

	     (case msg

	       ((len) size)

	       ;; ((ref)
	       ;;  (lambda (i)
	       ;;    (cond
	       ;;     ((>= i size)
	       ;;      (assertion-violation #f "Inside gro object: (>= i size)"))
	       ;;     (else
	       ;;      ((-> underlying 'ref) i)))))

               ((ref)
		(lambda (i)
		  (cond
		   ((>= i size)
		    (error "Inside gro object: (>= i size)"))
		   (else
		    ((-> underlying 'ref) i)))))

	       ((suffix)
		(lambda (elt)

                  (if (>= size (: underlying 'len))
		      (set! underlying
		            ((-> underlying 'copy)
		             (vec-of-len (* (: underlying 'len) 2)))))

		  ((-> underlying 'set) size elt)
		  (set! size (+ size 1))))

	       ((pop)
		(let ((elt ((-> underlying 'ref) (- size 1))))
		  ((-> underlying 'set) (- size 1) #f)
		  (set! size (- size 1))
		  elt))

	       ((show)
		(cons 'gro
		      (cdr
		       (-> ((-> underlying 'copy)
			    (vec-of-len size))
			   'show))))

	       ((raw)
		(vector (-> underlying 'raw) size))

               ((to-vec)
                (let ((new (vec-of-len size)))
                  (let ((each-index (-> new 'each-index))
                        (ref (-> underlying 'ref))
                        (set (-> new 'set)))
                    (let ((transfer
                           (lambda (i)
                             (set i (ref i)))))
                      (each-index transfer)))
                  new))

               ))))

      (vector 'gro #f message-handler))))