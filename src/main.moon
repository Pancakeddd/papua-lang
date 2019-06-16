import compilefile from require 'papua'
import parse_identifier, parse_typedefine, parse_define from require 'parser'

pprint = require 'pprint'

tok = compilefile "test.pua"
for x in *tok
  print x.value, x.name, x.start
pprint parse_define(tok, 1)