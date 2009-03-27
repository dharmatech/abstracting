
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (record-template-obj tag fields)

  (let ((fields (if (list? fields)
                    (vec-obj (list->vector fields))
                    fields)))

    (let ((index-of-field
           (lambda (field)
             ((-> fields 'index) (eq-to? field)))))

      (letrec ((record-obj
             
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

                             ((apply)
                              (lambda (procedure)
                                (apply procedure (vector->list data))))

                             ((clone)
                              (lambda ()
                                (record-obj
                                 (list->vector
                                  (vector->list data)))))

                             ))))

                    (vector tag data message-handler)))))

        (let ((new
               (lambda ()
                 (record-obj (make-vector (: fields 'len) #f))))

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

            (vector 'record-template (vector tag fields) message-handler)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Experimental
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (getter obj field) ((-> obj 'getter) field))
(define (setter obj field) ((-> obj 'setter) field))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (get obj field)     (((-> obj 'getter)  field)))
(define (set obj field val) (((-> obj 'setter!) field) val))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (change record field procedure)
  (set record field (procedure (get record field))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

