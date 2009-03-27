
(define (lis-obj l)

  (let (

        (ref
         (lambda (i)
           (list-ref l i)))

        (len
         (lambda ()
           (length l)))

        (push
         (lambda (elt)
           (lis-obj (cons elt l))))

        (push!
         (lambda (elt)
           (set! l (cons elt l))))

        (pop!
         (lambda ()
           (let ((elt (car l)))
             (set! l (cdr l))
             elt)))

        (apply
         (lambda (procedure)
           (apply procedure l)))

        )

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((map) (lambda (procedure)
                        (map procedure l)))

               ((each)
                (lambda (procedure)
                  (for-each procedure l)))

               ((empty?) (lambda () (null? l)))

               ((push!) push!)

               ((pop!) pop!)

               ;; ((cons!) cons!)

               ;; ((cdr!) cdr!)

               ((apply) apply)

               (else (lambda args (error "does not understand message")))))))

      (vector 'lis #f message-handler))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (lis . elts)
  (lis-obj elts))