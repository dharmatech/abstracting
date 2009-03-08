
(define (hashtable-obj table)

  (let ((message-handler

         (lambda (msg)

           (case msg

             ((len)
              (lambda ()
                (hashtable-size table)))

             ((ref)
              (lambda (key)
                (hashtable-ref table key #f)))

             ((set)
              (lambda (key val)
                (hashtable-set! table key val)))

             ((delete)
              (lambda (key)
                (hashtable-delete! table key)))

             ((contains?)
              (lambda (key)
                (hashtable-contains? table key)))

             ((clone)
              (lambda ()
                (hashtable-copy #t)))

             ((clear)
              (lambda ()
                (hashtable-clear! table)))

             ((keys)
              (lambda ()
                (hashtable-keys table)))

             ))))

    (vector 'hashtable table message-handler)))