-- peeks the token at the index
peek = (tok, i) ->
  tok[i]

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

parse_value = (tok, i) ->
  identifier = parse_identifier tok, i
  if identifier
    return identifier, i+1

parse_iexpr = (tok, i) ->
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

parse_define = (tok, i) ->
    idx = i
    td, tdi = parse_typedefine tok, idx
    if td
      idx = tdi
      sd, sdi = parse_simpledefine tok, idx
      pprint sd
      if sd
        idx = sdi
        return {
          name: "define"
          type: td
          set: sd
        }, idx



{:parse_identifier, :parse_typedefine, :parse_define}