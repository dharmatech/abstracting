
(case scheme-implementation

  ((chicken) (require-lib "r6rs-hashtable/chicken"))
  
  ((gambit) (require-lib "r6rs-hashtable/gambit")))