-- Util Functions

--- composes token table

token = (name, value) ->
    {
        :name
        :value
    }

--- throw lexical error (TODO, make more detailed, maybe "Did you mean x, y, z...?)

lexerr = (str) ->
    error "Lexical Error: #{str}"

-- simple string.sub reduction for ease of use

peek = (str, i) ->
    string.sub str, i, i

-- Filters

--- first part of identifier filter

is_identifier = (c) ->
    c\match "[a-zA-Z_]"

-- second part of identifier filter, picks up 0-9

is_identifier2 = (c) ->
    c\match "[a-zA-Z_0-9]"

-- simple filter base that tries to match as many chars that the filter picks up

matchwhile = (i, s, f) ->
    buff = ""
    while f peek s, i
        buff ..= peek s, i
        i += 1
    return buff

get_identifier = (i, s) -> -- TODO

{:matchwhile, :is_identifier}