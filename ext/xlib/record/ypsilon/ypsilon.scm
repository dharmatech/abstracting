
(define (xlib-record-template struct-name)

  (let ((make-from-ptr
         
         (lambda (ptr)
           
           (let ((message-handler

                  (lambda (msg)

                    (case msg

                      ((ptr) (lambda () ptr))

                      ((getter)
                       (lambda (field)
                         (let ((procedure

                                 (let ((getter-name
                                        (string->symbol
                                         (string-append (symbol->string struct-name)
                                                        "-"
                                                        (symbol->string field)))))

                                   (eval `(lambda (x) (,getter-name x))
                                         (interaction-environment)))))
                                   
                           (lambda ()
                             (procedure ptr)))))

                      ((setter!)
                       (lambda (field)
                         (let ((procedure
                                (let ((setter-name
                                       (string->symbol
                                        (string-append (symbol->string struct-name)
                                                       "-"
                                                       (symbol->string field)
                                                       "-set!"))))
                                  (eval `(lambda (bv val)
                                           (,setter-name bv val))
                                        (interaction-environment)))))
                           (lambda (val)
                             (procedure ptr val)))))))))

             (vector struct-name ptr message-handler)))))
    
    (let ((message-handler

           (lambda (msg)

             (case msg

               ((new)
                (let ((procedure
                       (eval
                        (string->symbol
                         (string-append "make-" (symbol->string struct-name)))
                        (interaction-environment))))
                  (lambda ()
                    (make-from-ptr (procedure)))))

               ((make) make-from-ptr)

               ))))

      (vector 'xlib-record-template struct-name message-handler))))