
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "glut/ypsilon"))
  
  ;; ((larceny) (load "/scratch/_glut-larceny-a.scm"))

  ((larceny) ((-> loader 'lib) "glut/larceny"))
  
  )

