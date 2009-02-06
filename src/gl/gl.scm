
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "gl/ypsilon"))
  ((larceny) (load "/scratch/_gl-larceny-b.scm")))

