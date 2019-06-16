import lex from require 'lex'

-- loads a file
load_file = (filename) ->
  with io.open filename, "r"
    s = \read "*all"
    \close!
    return s

-- compiles a inputed string, WIP
compile = (s) ->
  l = lex s
  return l

-- compiles a file, WIP
compilefile = (filename) ->
  compile load_file filename

{:compilefile, :compile}