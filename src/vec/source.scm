;; -*-scheme-*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define list-map map)

(define (for n fun) (do ((i 0 (+ i 1))) ((= i n)) (fun i)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vec-obj v)

  (let ((len (vector-length v))
	(ref (lambda (i)     (vector-ref  v i)))
	(set (lambda (i elt) (vector-set! v i elt))))

    (let ((index
	   (lambda (pred)
	     (let loop ((i 0))
	       (cond
		((= i len) #f)
		((pred (ref i)) i)
		(else (loop (+ i 1)))))))

	  (each-index
	   (lambda (fun)
	     (do ((i 0 (+ i 1)))
		 ((= i len))
	       (fun i)))))

      (let ((clone
	     (lambda ()
	       (let ((new (vec-of-len len)))
		 (let ((set (-> new 'set)))
		   (each-index (lambda (i) (set i (ref i)))))
		 new)))

	    (map!
	     (lambda (fun)
	       (each-index
		(lambda (i)
		  (set i (fun (ref i)))))))

	    (each
	     (lambda (fun)
	       (each-index
		(lambda (i)
		  (fun (ref i))))))

	    (find
	     (lambda (pred)
	       (let ((i (index pred)))
		 (if i (ref i) #f))))

	    (subseq
	     (lambda (a b)
	       (let ((n (- b a)))
		 (let ((new (vec-of-len n)))
		   (let ((set (-> new 'set)))
		     ((-> new 'each-index)
		      (lambda (i)
			(set i (ref (+ a i))))))
		   new)))))

	(let ((map
	       (lambda (fun)
		 (let ((new (clone)))
		   ((-> new 'map!) fun)
		   new)))

	      (head (lambda (n) (subseq 0 n)))

	      (tail (lambda (n) (subseq n len))))

	  (let ((message-handler

		 (lambda (msg)

		   (case msg

		     ((len) (lambda () len))
                     
		     ((ref) ref)
		     ((set) set)
		     
		     ((index) index)
		     ((each-index) each-index)
		     
		     ((clone) (clone))
		     ((map!) map!)
		     ((each) each)
		     ((find) find)
		     ((subseq) subseq)
		     
		     ((map) map)
		     ((head) head)
		     ((tail) tail)

		     ((first)	(lambda () (ref 0)))
		     ((second)	(lambda () (ref 1)))
		     ((third)	(lambda () (ref 2)))
		     ((fourth)	(lambda () (ref 3)))
		     ((fifth)	(lambda () (ref 4)))
		     ((sixth)	(lambda () (ref 5)))
		     ((seventh)	(lambda () (ref 6)))
		     ((eight)	(lambda () (ref 7)))
		     ((ninth)	(lambda () (ref 8)))
		     ((tenth)	(lambda () (ref 9)))

		     ((copy)
		      (lambda (new)
			(let ((set (-> new 'set)))
			  (for (min len (: new 'len))
			       (lambda (i)
				 (set i (ref i)))))
			new))

		     ((suffix)
		      (lambda (elt)
			(let ((new (vec-of-len (+ len 1))))
			  (let ((set (-> new 'set)))
			    (for len
				 (lambda (i)
				   (set i (ref i))))
			    (set len elt))
			  new)))

                     ((prefix)
                      (lambda (elt)
			(let ((new (vec-of-len (+ len 1))))
			  (let ((set (-> new 'set)))
			    (for len
				 (lambda (i)
				   (set (+ i 1) (ref i))))
			    (set 0 elt))
			  new)))

		     ((show)
		      (cons 'vec
			    (list-map (lambda (obj)
					(if (obj? obj)
					    (-> obj 'show)
					    obj))
				      (vector->list v))))

		     ;; ((filter)
		     ;;  (lambda (predicate)
		     ;;    (let ((new (gro-obj len)))
                     ;;      (let ((push (-> new 'suffix)))
                     ;;        (let ((push-if
                     ;;               (lambda (elt)
                     ;;                 (if (predicate elt)
                     ;;                     (push elt)))))
                     ;;          (each push-if)))
                     ;;      (-> new 'to-vec))))

                     ((filter)
                      (lambda (predicate)

                        (let ((items '()))

                          (each
                           (lambda (elt)
                             (if (predicate elt)
                                 (set! items (cons elt items)))))

                          (vec-obj (list->vector (reverse items))))))

		     ;; ((remove)
		     ;;  (lambda (predicate)
		     ;;    ((-> self 'filter)
		     ;;     (lambda (elt) (not (predicate elt))))))

		     ;; tbl

		     ((tbl-ref)
		      (lambda (key)
			(let ((result (find (lambda (elt)
					      (equal? (: elt 'first) key)))))
			  (if result (-> result 'second) #f))))

		     ((tbl-set)
		      (lambda (key val)
			(let ((result (find (lambda (elt)
					      (equal? (: elt 'first) key)))))
			  (if result
			      ((-> result 'set) 1 val)
			      #f))))

		     ;;

                     ((apply)
                      (lambda (procedure)
                        (apply procedure (vector->list v))))

		     ;;

		     ;; ((sort)
		     ;;  (lambda (strictly-less-than?)
		     ;;    (vec-obj
		     ;;     (vector-sort strictly-less-than? v))))

		     ;; ((sort!)
		     ;;  (lambda (strictly-less-than?)
		     ;;    (vector-sort! strictly-less-than? v)))

		     ;;

		     ((sum)
		      (let ((accum 0))
			(each
			 (lambda (elt)
			   (set! accum (+ accum elt))))
			accum))

		     ;;

		     ((/n)
		      (lambda (n)
		        (map
		         (lambda (elt)
		           (/ elt n)))))

                     ;;

                     ((reduce)
                      (lambda (f ridentity)
                        (let ((accum ridentity))
                          (each
                           (lambda (elt)
                             (set! accum (f accum elt))))
                          accum)))
                     
		     ((rest) (tail 1))

                     ;;

                     ((empty?) (lambda () (= len 0)))

		     ;;

		     ((raw) v)

                     ;; Resizable support. Experimental.
                     
                     ;; Alt names: (set-fill!) (push-fill!)
                     
                     ((set-len!) (lambda (new) (set! len new)))

                     ((push!)
                      (lambda (elt)
                        (set len elt)
                        (set! len (+ len 1))))

                     ((filter-into-vec!)
                      (lambda (f u)
                        (let ((push! (-> u 'push!)))
                          (each
                           (lambda (elt)
                             (if (f elt)
                                 (push! elt)))))))

                     ;;

                     ((filter-to-list)
                      (lambda (pred)

                        (let loop ((i 0))

                          (cond ((= i len) '())

                                ((pred (ref i))
                                 (cons (ref i)
                                       (loop (+ i 1))))

                                (else (loop (+ i 1)))))))
                     
		     ))))

	  (vector 'vec v message-handler)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vec . elts)   (vec-obj (apply vector elts)))

(define (vec-of-len n) (vec-obj (make-vector n #f)))

(define (int-to-vec n)
  (let ((new (vec-of-len n)))
    (let ((set (-> new 'set)))
      ((-> new 'each-index) (lambda (i) (set i i))))
    new))

(define (vec-from-list l)
  (vec-obj (list->vector l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
