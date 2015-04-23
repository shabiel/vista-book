circumference ; calculate the circumference of a circle ; label line
 ; level line
 ;
 write "Sorry. No entry from the top is allowed.",!! ; level line
 quit
 ;
main ; Main entry point
 new rad,x
 read "type enter to begin: ",x,!
 write !!
 read "Enter a radius: ",rad,!
 write !!
 new circumference set circumference=$$calculate(rad)
 write "circumference is "_circumference,!
 quit
 ;
calculate(radius) ; formal line. Formal list contains one variable
 new circ
 set circ=2*3.14*radius ; 2 pi r 
 quit circ
 ;
