
(define (record-template-obj tag fields)

  (let ((index-of-field
         (lambda (field)
           ((-> fields 'index) (eq-to? field)))))

    (let ((record-obj
           
           (lambda (data)

             (let ((message-handler

                    (lambda (msg)

                      (case msg

                        ((getter)
                         (lambda (field)
                           (let ((i (index-of-field field)))
                             (lambda ()
                               (vector-ref data i)))))

                        ((setter!)
                         (lambda (field)
                           (let ((i (index-of-field field)))
                             (lambda (val)
                               (vector-set! data i val)))))

                        (else ;; Treat message as field name; dynamic dispatch.

                         (let ((i ((-> fields 'index) (eq-to? msg))))
                           (if i (vector-ref data i) #f)))))))

               (vector tag data message-handler)))))

      (let ((new
             (lambda ()
               (record-obj (make-vector (-> fields 'len) #f))))

            (boa
             (lambda args
               (record-obj (apply vector args)))))

        (let ((message-handler

               (lambda (msg)

                 (case msg

                   ((new) new)
                   ((boa) boa)
                   ((make) #t)

                   ((getter)
                    (lambda (field)
                      (let ((i (index-of-field field)))
                        (lambda (obj)
                          (vector-ref (vector-ref obj 1) i)))))

                   ((setter!)
                    (lambda (field)
                      (let ((i (index-of-field field)))
                        (lambda (obj val)
                          (vector-set! (vector-ref obj 1) i val)))))))))

          (vector 'record-template (vector tag fields) message-handler))))))