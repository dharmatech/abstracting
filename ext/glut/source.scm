
(case scheme-implementation

  ((ypsilon) (require-lib "glut/ypsilon"))
  ((larceny) (require-lib "glut/larceny"))
  ((ikarus)  (require-lib "glut/ikarus"))
  ((chicken) (require-lib "glut/chicken"))

  ((gambit)
   (load (string-append abstracting-root-directory "/support/gambit/glut/glut")))
  
  )

