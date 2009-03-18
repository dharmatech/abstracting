
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (double-vector-obj bv)

  (let ((len (/ (bytevector-length bv) 8))
        
        (ref
         (lambda (i)
           (bytevector-ieee-double-native-ref bv (* i 8))))
        
        ;; (set!
        ;;  (lambda (i val)
        ;;    (bytevector-ieee-double-native-set! bv (* i 8) val)))

        (set!
         (lambda (i val)
           (bytevector-ieee-double-native-set! bv (* i 8) (inexact val))))

        )

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((len) len)
               ((ref) ref)
               ((set!) set!)

               ((raw) bv)

               ))))

      (vector 'double-vector bv message-handler))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (double-vector-of-len n) (double-vector-obj (make-bytevector (* n 8))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (double-vector . elts)

  (let ((v (apply vec elts)))

    (let ((bv (double-vector-of-len (: v 'len))))

      (let ((ref  (-> v  'ref))
            (set! (-> bv 'set!)))

        ((-> v 'each-index)
         (lambda (i)
           (set! i (ref i)))))

      bv)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
