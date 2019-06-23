import compilefile from require 'papua'
import parse_identifier, parse_typedefine, parse_define, parse, parse_fundefine from require 'parser'
import env from require 'env'
import compilem from require 'compile'

pprint = require 'pprint'

tok = compilefile "test.pua"
for x in *tok
  print x.value, x.name, x.start

e = env!

ast = parse(tok, 1)
pprint ast
print compilem ast, e