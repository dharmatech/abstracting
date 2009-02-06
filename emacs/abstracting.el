
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun insert-open-parentheses ()
  (interactive)
  (insert "("))

(defun insert-close-parentheses ()
  (interactive)
  (insert ")"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun scheme-insert-define ()
  (interactive)
  (insert "(define ("))

(defun scheme-insert-lambda ()
  (interactive)
  (insert "(lambda ("))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'scheme)

(define-key scheme-mode-map (kbd "[") 'insert-open-parentheses)
(define-key scheme-mode-map (kbd "]") 'insert-close-parentheses)

(define-key scheme-mode-map (kbd ";") 'scheme-insert-define)

(define-key scheme-mode-map (kbd "<return>") 'newline-and-indent)

(define-key scheme-mode-map (kbd "\\") 'scheme-insert-lambda)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cmuscheme)

(define-key inferior-scheme-mode-map (kbd "[") 'insert-open-parentheses)
(define-key inferior-scheme-mode-map (kbd "]") 'insert-close-parentheses)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

