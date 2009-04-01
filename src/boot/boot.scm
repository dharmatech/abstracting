
(define abstracting-root-directory (current-directory))

(set! *roots* (list (string-append abstracting-root-directory "/src")
                    (string-append abstracting-root-directory "/ext")
                    (string-append abstracting-root-directory "/examples")
                    (string-append abstracting-root-directory "/experimental")))

