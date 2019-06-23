-- peeks the token at the index
peek = (tok, i) ->
  tok[i]

ret = (x) ->
  return {
    name: "return"
    value: x
  }

parerror = (str, tok, idx) ->
  if tok
    error "Parse Error: #{str} at #{tok.start}"
  if idx
    error "Parse Error: #{str} at #{idx}"

-- parses identifier
parse_identifier = (tok, i) ->
  idx = i
  if peek(tok, idx) and peek(tok, idx).name == "identifier"
    v = peek(tok, idx).value
    idx += 1
    return {
      name: "identifier"
      value: v
    }, idx

  -- parses number
parse_number = (tok, i) ->
  idx = i
  if peek(tok, idx) and peek(tok, idx).name == "number"
    v = peek(tok, idx).value
    idx += 1
    return {
      name: "number"
      value: v
    }, idx

parse_value = (tok, i) ->
  identifier = parse_identifier tok, i
  if identifier
    return identifier, i+1

  number = parse_number tok, i
  if number
    return number, i+1

parse_call = (tok, i) ->

parse_op = (tok, i) ->
  idx = i
  v, vi = parse_value tok, idx
  if v
    idx = vi
    if peek(tok, idx) and peek(tok, idx).name == "op"
      op = peek(tok, idx).value
      idx += 1
      v2, v2i = parse_op tok, idx
      if v2
        return {
          name: "op"
          value1: v
          :op
          value2: v2
        }, v2i
      else -- Expected value after op
        parerror "Expected something after '#{peek(tok, idx-1).value}'", nil, idx
    else
      return v

parse_iexpr = (tok, i) ->
  op, idx = parse_op tok, i
  if op
    return op, idx

  value, idx = parse_value tok, i
  if value
    return value, idx

-- parses typeblock for use of typedefine
parse_typeblock = (tok, i) ->
  idx = i
  ident = parse_identifier tok, idx
  if ident
    idx += 1
    if peek(tok, idx) and peek(tok, idx).name == "arrow"
      idx += 1
      z, iz = parse_typeblock tok, idx
      if z
        idx = iz
        return {
          name: "typeblock"
          value1: ident
          value2: z
        }, idx
      else -- Arrow Error
        parerror "Expected an identifier et al after '->' (arrow) in typeblock", nil, idx
    else
      return ident, idx

-- simple definition (aka. "a = 10")
parse_simpledefine = (tok, i) ->
  idx = i
  ident = parse_identifier tok, idx
  if ident
    idx += 1
    if peek(tok, idx) and peek(tok, idx).name == "set"
      idx += 1
      v, vi = parse_iexpr tok, idx
      if v
        idx = vi
        {
          name: "set"
          value1: ident
          value2: v
        }, idx
      else
        parerror "Expected an iexpression (what you'd expect after '=') after '=' (equals) in define", nil, idx

parse_fundefine = (tok, i) ->
  idx = i
  ident = parse_identifier tok, idx
  if ident
    idx += 1
    a = {}
    while true
      p = parse_identifier tok, idx
      if p
        idx += 1
        table.insert a, p
      else
        break
    if #a > 0
      if peek(tok, idx) and peek(tok, idx).name == "set"
        idx += 1
        v, vi = parse tok, idx
        if v
          idx = vi
          {
            name: "setf"
            value1: ident
            value1args: a
            value2: v
          }, idx
      

-- parses typedefine for use of common definitions
parse_typedefine = (tok, i) ->
  idx = i
  ident = parse_identifier tok, idx
  if ident
    idx += 1
    if peek(tok, idx) and peek(tok, idx).name == "doublecolon"
      idx += 1
      z, zi = parse_typeblock tok, idx
      if z
        idx = zi
        return {
          name: "typedefine"
          setname: ident
          value: z
        }, idx
      else -- Double Colon Error
        parerror "Expected an identifier et al after '::' (doublecolon) in typeblock", nil, idx

pprint = require 'pprint'

parse_def = (tok, i) ->
  definef, idx = parse_fundefine tok, i
  if definef
    return definef, idx

  define, idx = parse_simpledefine tok, i
  print define
  if define
    return define, idx

parse_define = (tok, i) ->
    idx = i
    td, tdi = parse_typedefine tok, idx
    if td
      idx = tdi
      sd, sdi = parse_def tok, idx
      pprint sd
      if sd
        idx = sdi
        return {
          name: "define"
          type: td
          set: sd
        }, idx
      else
        parerror "Expected a define archetype (a = 10 et al) inside bigger define block", nil, idx

parse_sexpr = (tok, i) ->
  definef, idx = parse_fundefine tok, i
  if definef
    return definef, idx

  define, idx = parse_define tok, i
  print define
  if define
    return define, idx

export parse_expr = (tok, i) ->
  sexpr, idx = parse_sexpr tok, i
  if sexpr
    return sexpr, idx

  iexpr, idx = parse_iexpr tok, i
  if iexpr
    return iexpr, idx

export parse = (tok, i) ->
  idx = i
  ast = {}
  while true
    a, ai = parse_expr tok, idx
    if a
      pprint a
      table.insert ast, a
      idx = ai
    else
      return ast

{:parse_identifier, :parse_typedefine, :parse_define, :parse, :parse_fundefine}