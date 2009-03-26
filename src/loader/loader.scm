
(define (make-loader)

  (let ((roots  (vec))
        (loaded (vec)))

    (let ((resolve-file
           (lambda (file)
             (let ((root ((-> roots 'find)
                          (lambda (root)
                            (file-exists? (string-append root "/" file))))))
               (if root (string-append root "/" file) #f)))))

      (let ((get-lib
             (lambda (name)

               (let ((base-name (cond ((string-index-right name #\/) =>
                                       (lambda (i)
                                         (string-drop name (+ i 1))))
                                      (else name)))

                     (loaded?
                      (lambda ()
                        (: loaded 'find (lambda (elt) (equal? name elt))))))

                 (let ((relative-source-file
                        (string-append name "/" base-name ".scm"))

                       ;; (relative-compiled-file
                       ;;  (string-append
                       ;;   name "/" (base-name->compiled-file-name name)))

                       )

                   (let (
                         (source-file
                          (lambda ()
                            (resolve-file relative-source-file)))

                         ;; (compiled-file
                         ;;  (lambda ()
                         ;;    (resolve-file relative-compiled-file)))
                         )

                     (let ((load-source
                            (lambda ()
                              (scheme-load-source-file (source-file))))

                           ;; (compile
                           ;;  (lambda ()
                           ;;    (scheme-compile-file (source-file))))

                           (edit
                            (lambda ()
                              (system
                               (string-append
                                "emacsclient --create-frame --no-wait "
                                (source-file)))))
                           
                           )

                       (let ((use
                              (lambda ()
                                (if (not (loaded?))
                                    (begin
                                      (print "Loading " name "\n")
                                      (load-source)
                                      (set! loaded (: loaded 'suffix name))
                                      'ok)))))

                         (let ((message-handler
                                (lambda (msg)
                                  (case msg

                                    ((use) use)

                                    ((load-source) load-source)

                                    ;; ((compile) compile)

                                    ((source-file)   source-file)

                                    ;; ((compiled-file) compiled-file)

                                    ((loaded?) loaded?)

                                    ((edit) edit)
                                    
                                    ))))

                           (vector 'lib name message-handler))))))))))

        (let ((message-handler

               (lambda (msg)

                 (case msg

                   ((roots)  (lambda () roots))
                   ((loaded) (lambda () loaded))

                   ((prefix-root)
                    (lambda (root)
                      (set! roots (: roots 'prefix root))))

                   ((suffix-root add-root)
                    (lambda (root)
                      (set! roots (: roots 'suffix root))))

                   ((set-roots)
                    (lambda (new)
                      (set! roots new)))

                   ((get-lib) get-lib)

                   ;; backwards compatability
                   
                   ((lib)
                    (lambda (name)
                      (: (get-lib name) 'use)))))))

        (vector 'loader #f message-handler))))))