module IDE

import Syntax;
import AST;
import CST2AST;
import Check;
import Compile;

import util::IDE;
import Message;
import ParseTree;


private str csv ="CSV";

anno rel[loc, loc] Tree@hyperlinks;

void main() {
  registerLanguage(csv, "csv", Tree(str src, loc l) {
    return parse(#start[Table], src, l);
  });
  
  contribs = {
    annotator(Tree(Tree t) {
      if (start[Table] pt := t) {
        ATable ast = cst2ast(pt);
        set[Message] msgs = check(ast);
        return t[@messages=msgs][@hyperlinks=useDef];
      }
      return t[@messages={error("Not a table", t@\loc)}];
    }),
    
    builder(set[Message] (Tree t) {
      if (start[Table] pt := t) {
        ATable ast = cst2ast(pt);
        set[Message] msgs = check(ast);
        
        set[Message] errors = { e | e:error(str msg, loc u) <- msgs};
        if (errors == {}) {
          compile(ast);
        }
        return msgs;
      }
      return {error("Not a table", t@\loc)};
    })
  };
  
  registerContributions(csv, contribs);
}
