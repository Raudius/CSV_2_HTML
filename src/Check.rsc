module Check

import AST;

import List;
import String;
import Message;

/* CSV checker
 * Gives error if:
 *   - Row size does not match header size.
 *
 * Gives warning if:
 *   - A field is empty
 *   - Two columns have the same header 
 */

// returns the primitive value for a field
value getValue(strField(str s)) = s;
value getValue(intField(int i)) = i;


set[Message] check(ATable f)
  = check(f.rows);

// dont do any checks on a table with no rows
set[Message] check([]) = {};

// Perform all check on the table
set[Message] check(list[ARow] rows) 
  = checkEmptyFields(rows) 
  + checkRowSizes(rows)
  + checkDupHeaders(rows[0].fields);


// Checks if any headers are duplicates
set[Message] checkDupHeaders(list[AField] fields) {
  set[Message] msgs = {};
  map[value, AField] headers = ();
  for(AField f <- fields) {
    value v = getValue(f);
    if(v in headers) {
      msgs += warning("Duplicate header name: <v>", f.src);
      msgs += warning("Duplicate header name: <v>", headers[v].src);
    }
    
    headers += (v:f);
  }
  return msgs;
}


// Check for empty fields
set[Message] checkEmptyFields(list[ARow] rows)
  = { *checkEmptyFields(r.fields) | ARow r <- rows };
set[Message] checkEmptyFields(list[AField] fields)
  = { warning("Field is empty.", f.src) | f:strField(str s) <- fields, isEmpty(s) };

// Check for all rows: size(row) == size(rows[0])
set[Message] checkRowSizes(list[ARow] rows)
 = { error("Row size does not match header size.", r.src) 
      | ARow r <- rows, size(r.fields) != size(rows[0].fields) };
