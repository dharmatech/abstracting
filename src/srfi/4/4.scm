
(case scheme-implementation

  ((ypsilon) (: loader 'lib "srfi/4/r6rs"))

  ((chicken) (: loader 'lib "srfi/4/chicken")))