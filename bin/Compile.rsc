module Compile

import String;
import Check;
import AST;
import IO;
import lang::html5::DOM;

import Type;
import Syntax;
import ParseTree;
import CST2AST;


/* CSV to HTML compiler
 * Compiles the CSV abstract syntax tree into a HTML file.
 * HTML displays a <table> with the data from the input CSV.
 */

void compile(ATable t) = writeFile(t.src[extension="html"].top, toString(csv2html(t)));


// convert Rascal primitives to HTML strings, remove quotation marks from strings
value csv2html(strField(str s)) = replaceAll(s, "\"", "");
value csv2html(intField(int i)) = "<i>";

// creates the HTML fields <td>
list[HTML5Node] csv2html(list[AField] fields) 
  = [ td( csv2html(f) ) | AField f <- fields ];

// creates the HTML rows <tr>
list[HTML5Node] csv2html(list[ARow] rows) 
  = [ tr( csv2html(r.fields) ) | ARow r <- rows ];

// Creates a HTML table form the CSV
HTML5Node csv2html(ATable t) =
  html( 
   head(
      // simple styling for table
      style("table, th, td { border-collapse: collapse;  border:1px solid black; }  td { padding:4px; min-width:150px; max-width: 350px;}")), 
   body(
    table(
      csv2html(t.rows) // create all HTML rows <tr>
    )
   )
  );



