peek = (tok, i) ->
  tok[i]

parse_identifier = (tok, i) ->
  idx = i
  if peek(tok, idx) and peek(tok, idx).name == "identifier"
    v = peek(tok, idx).value
    idx += 1
    return {
      name: "identifier"
      value: v
    }, idx

parse_typeblock = (tok, i) ->
  idx = i
  ident = parse_identifier tok, idx
  if ident
    idx += 1
    if peek(tok, idx) and peek(tok, idx).name == "arrow"

parse_typedefine = (tok, i) ->
  idx = i
  ident = parse_identifier tok, idx
  if ident
    idx += 1
    if peek(tok, idx) and peek(tok, idx).name == "doublecolon"
      idx += 1
      -- TODO



{:parse_identifier}