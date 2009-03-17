
;; dependencies
;;
;; (current-directory [dir])
;;
;; (file-exists? path-string)

(define abstracting-root-directory (current-directory))

(current-directory "src")

(load "obj/obj.scm")
(load "vec/vec.scm")
(load "path/path.scm")
(load "loader/loader.scm")

(current-directory "..")

(define loader (make-loader))

((-> loader 'add-root) (string-append (current-directory) "/src"))
((-> loader 'add-root) (string-append (current-directory) "/ext"))
((-> loader 'add-root) (string-append (current-directory) "/examples"))
((-> loader 'add-root) (string-append (current-directory) "/experimental"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helper for the '--lib' command line option

(define-macro (loader-lib name)
  `((-> loader 'lib) (symbol->string ',name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (print . args)
  (for-each display args))

