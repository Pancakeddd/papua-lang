import matchwhile, getidentifier, nexttoken, lex from require 'lex'

-- Placeholder! Testing lexing.

tok = lex "ab :: gab"
for x in *tok
    print x.value, x.name