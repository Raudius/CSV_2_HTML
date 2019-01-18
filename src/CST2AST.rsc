module CST2AST

import Syntax;
import AST;

import ParseTree;
import String;
import IO;

// Concrete Syntax -> Abstract Syntax


ATable cst2ast(start[Table] sf) = cst2ast(sf.top);

ATable cst2ast(t:(Table)`<Row* rs>`)
 = table([ cst2ast(r) | Row r <- rs], src=t@\loc);


ARow cst2ast(r:(Row) `<Field sf><NextField* fs><Newline nl>`)
 = row( cst2ast(sf) + [cst2ast(f) | NextField f <- fs], src=r@\loc );

AField cst2ast((NextField) `,<Field f>`) = cst2ast(f);

AField cst2ast(f:(NextField) `,`) = strField("", src=f@\loc);

AField cst2ast(f:(Field) `<Str s>`) = strField("<s>", src=f@\loc);
AField cst2ast(f:(Field) `<Int i>`) = intField(toInt("<i>"), src=f@\loc);
AField cst2ast(f:(Field) ``) = strField((""), src=f@\loc);

