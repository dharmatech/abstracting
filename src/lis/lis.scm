
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define list-length   length)
(define list-map      map)
(define list-for-each for-each)

(define list-find   find)
(define list-filter filter)

(define list-apply apply)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (lis-obj l)

  (let (
        
        (len (lambda ()      (list-length l)))
        (ref (lambda (i)     (list-ref    l i)))
        (set (lambda (i elt) (list-set!   l i)))

        (map (lambda (f) (lis-obj (list-map f l))))

        (each (lambda (f) (list-for-each f l)))

        (find (lambda (f) (list-find f l)))

        (filter (lambda (f) (lis-obj (list-filter f l))))

        (apply (lambda (f) (list-apply f l)))

        )

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((len) len)
               ((ref) ref)
               ((set) set)
               ((map) map)
               ((each) each)
               ((find) find)

               ))))

      (vector 'lis l message-handler))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (lis . elts)
  (lis-obj elts))