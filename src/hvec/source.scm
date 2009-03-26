
(case scheme-implementation

  ;; ((chicken ypsilon larceny gambit) (: loader 'lib "hvec/srfi-4"))

  ((chicken ypsilon larceny gambit) (require-lib "hvec/srfi-4"))

  ;; ((ypsilon) (: loader 'lib "hvec/r6rs-bytevectors"))

  )