module AST

// Abstract Syntax Tree for CSV

data ATable(loc src = |tmp:///|)
  = table(list[ARow] rows)
  ;

data ARow(loc src = |tmp:///|)
  = row(list[AField] fields)
  ;

data AField(loc src = |tmp:///|)
  = strField(str string)
  | intField(int integer)
  ;


