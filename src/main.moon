import compile from require 'papua'
import parse_identifier from require 'parser'

tok = compile "ab :: \ngab a"
for x in *tok
  print x.value, x.name, x.start
print "araerearaew", parse_identifier(tok, 1).value