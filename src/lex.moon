--
--    Util
--

--- composes token table
token = (name, value, start) ->
    {
        :name
        :value
        :start
    }

--- throw lexical error (TODO: make more detailed? maybe "Did you mean x, y, z...?")
lexerr = (str) ->
    error "Lexical Error: #{str}"

-- simple string.sub reduction for ease of use
peek = (str, i) ->
    if i > #str
        return nil
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

-- gets symbol if it exists
getsymbol = (sym, i, s) ->
    idx = i
    otraidx = 1
    buff = ""
    print s
    while peek(s, idx) == peek(sym, otraidx) and peek(s, idx) ~= nil
        buff ..= peek s, idx
        otraidx += 1
        idx += 1
    return idx if buff == sym
    return false

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
        
-- gets identifier
getidentifier = (i, s) ->
    token("identifier", matchwhileswitch(i, s, is_identifier, is_identifier2), i), i

-- gets double colon
getdoublecolon = (i, s) ->
    x, ni = getsymbol "::", i, s
    return token("doublecolon", "::", i), ni if x ~= false

nexttoken = (s, i) ->
    if peek(s, i)\match "[ \t\n]" -- Skip white space and other fluff
        return nexttoken s, i+1

    doublecolon, ni = getdoublecolon i, s
    if doublecolon
        return doublecolon, ni

    identifier, ni = getidentifier i, s
    if identifier
        return identifier, ni

-- simple lexer that marches nexttoken, TODO
lex = (s) ->


{:matchwhile, :getidentifier, :nexttoken}