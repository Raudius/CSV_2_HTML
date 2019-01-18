module Syntax

/* CSV syntax 
 *  expects to end with an empty line
 *  does NOT allow for empty lines between rows
 *  does NOT allow for space separated fields (spaces in strings is OK)
 *  allows for empty fields ie. ,,
 *  allows for integers or string fields ie "string", 1,...
 */

start syntax Table 
  = Row*;	// Each row must be followed by a new line
  

syntax Row = Field NextField* Newline;

syntax NextField
 = "," Field
 | ","; // empty Field

syntax Field = Str | Int;

lexical Str =  "\"" ![\"]* "\"" ;
lexical Int = [0-9]+;
lexical Newline 
  = [\r][\n]
  > [\n]
  > [\r]
  ;