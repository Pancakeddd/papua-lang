--
--    Util
--

--- composes token table
token = (name, value) ->
    {
        :name
        :value
    }

--- throw lexical error (TODO: make more detailed? maybe "Did you mean x, y, z...?")
lexerr = (str) ->
    error "Lexical Error: #{str}"

-- simple string.sub reduction for ease of use
peek = (str, i) ->
    string.sub str, i, i

--
--  Filters
--

--- first part of identifier filter
is_identifier = (c) ->
    c\match "[a-zA-Z_]"

-- second part of identifier filter, picks up 0-9
is_identifier2 = (c) ->
    c\match "[a-zA-Z_0-9]"

-- simple filter base that tries to match as many chars that the filter picks up
matchwhile = (i, s, f) ->
    idx = i
    buff = ""
    while f peek s, idx
        buff ..= peek s, idx
        idx += 1
    return buff, idx

-- filter system where only the first character is filtered by f1, all others by f2
matchwhileswitch = (i, s, f1, f2) ->
    idx = i
    buff = ""
    f = f1
    while f peek s, idx
        f = f2 if f == f1
        buff ..= peek s, idx
        idx += 1
    return buff, idx
        

getidentifier = (i, s) -> -- TODO
    matchwhileswitch i, s, is_identifier, is_identifier2

{:matchwhile, :getidentifier}