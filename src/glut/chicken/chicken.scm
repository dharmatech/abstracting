
(chicken-scheme-load
 (string-append abstracting-root-directory "/support/chicken/glut/glut.so"))

(define (glutInit x y) #t)