import compilefile from require 'papua'
import parse_identifier, parse_typedefine, parse_define from require 'parser'
import env from require 'env'
import compile from require 'compile'

pprint = require 'pprint'

tok = compilefile "test.pua"
for x in *tok
  print x.value, x.name, x.start

e = env!

ast = parse_define(tok, 1)
pprint ast
print compile ast, e