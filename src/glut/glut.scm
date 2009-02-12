
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "glut/ypsilon"))
  
  ((larceny) ((-> loader 'lib) "glut/larceny"))

  ((chicken) ((-> loader 'lib) "glut/chicken"))
  
  )

