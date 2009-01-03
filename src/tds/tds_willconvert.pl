#!perl

printf qq(/* %s */\n), '($Id: tds_willconvert.pl,v 1.3 2009/01/03 15:26:09 jklowden Exp $)';
printf qq(/*** %-67s ***/\n), "Please do not edit this file!";
printf qq(/*** %-67s ***/\n), "It was generated with 'perl tds_willconvert.pl > tds_willconvert.h'";
printf qq(/*** %-67s ***/\n), "It is much easier to edit the __DATA__ table than this file.  ";
printf qq(/*** %-67s ***/\n), " ";
printf qq(/*** %67s ***/\n\n), "Thank you.";

%yn = 	( T => 1
	, t => 0	# should be true, but not yet implemented.
	, F => 0
	);

$indent = "\t ";

while(<DATA>) {
	next if /^\s+To\s*$/;
	next if /^From/;
	if( /^\s+VARCHAR CHAR/ ) {
		@to = split;
		next;
	}
	last if /^\s*$/;

	@yn = split;
	$from = shift @yn;
	$i = 0;
	foreach $to (@to) {
		printf "$indent %-35s, %s }\n", "{ SYB${from}, SYB${to}", $yn{$yn[$i++]}; 
		$indent = "\t,";
	}
}

__DATA__
          To
From
          VARCHAR CHAR TEXT BINARY VARBINARY IMAGE INT1 INT2 INT4 INT8 FLT8 REAL NUMERIC DECIMAL BIT MONEY MONEY4 DATETIME DATETIME4 BOUNDARY UNIQUE SENSITIVITY
VARCHAR     T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  T	   T	     T        T        t
CHAR        T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  T	   T	     T        T        t
TEXT        T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  T	   T	     T        T        t
BINARY      T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
VARBINARY   T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
IMAGE       T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
INT1        T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
INT2        T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
INT4        T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
INT8        T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
FLT8        T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
REAL        T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
NUMERIC     T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
DECIMAL     T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
BIT         T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
MONEY       T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
MONEY4      T      T   T    T	   T         T     T	T    T    T    T    T	 T	 T	 T   T     T	  F	   F	     F        F        F
DATETIME    T      T   T    T	   T         T     F	F    F    F    F    F	 F	 F	 F   F     F	  T	   T	     F        F        F
DATETIME4   T      T   T    T	   T         T     F	F    F    F    F    F	 F	 F	 F   F     F	  T	   T	     F        F        F
BOUNDARY    T      T   T    F	   F         F     F	F    F    F    F    F	 F	 F	 F   F     F	  F	   F	     T        F        F
UNIQUE      T      T   T    F	   F         F     F	F    F    F    F    F	 F	 F	 F   F     F	  F	   F	     F        T        F
SENSITIVITY t      t   t    F	   F         F     F	F    F    F    F    F	 F	 F	 F   F     F	  F	   F	     F        F        t
