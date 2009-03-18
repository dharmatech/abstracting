
(case scheme-implementation
  ((ypsilon) (: loader 'lib "srfi/1/ypsilon"))
  ((larceny) (: loader 'lib "srfi/1/larceny"))
  ((chicken) (: loader 'lib "srfi/1/chicken")))