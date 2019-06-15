import matchwhile, getidentifier, nexttoken from require 'lex'

-- Placeholder! Testing lexing.

tok = nexttoken("  za ", 1)
print tok.value, tok.start