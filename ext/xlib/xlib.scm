
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "xlib/ypsilon"))

  ((chicken) ((-> loader 'lib) "xlib/chicken"))

  ((larceny) ((-> loader 'lib) "xlib/larceny"))

  )