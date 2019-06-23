--
--    Util
--

DidYouMean = {
	"[": "'('"
	"]": "')'"
	":": "'::'"
	":=": "'='"
}

--- composes token table
token = (name, value, start) ->
	{
			:name
			:value
			:start
	}

-- simple string.sub reduction for ease of use
peek = (str, i) ->
	if i > #str
		return nil
	string.sub str, i, i

-- converts char index and string into line index
findlineposition = (s, i) ->
	idx = 1
	line = 1
	while true
		if peek(s, idx) == nil or idx == i
			return line
		if peek(s, idx) == "\n"
			line += 1
		idx += 1

--- throw lexical error (TODO: make more detailed? maybe "Did you mean x, y, z...?")
lexerr = (str, s, idx, l) ->
	didyoumean = ""
	if DidYouMean[l]
		didyoumean = ", Did you mean #{DidYouMean[l]}?"
	if idx and s
		error "Lexical Error: #{str} at line #{findlineposition s, idx}#{didyoumean}"
	error "Lexical Error: #{str}#{didyoumean}"

--
--  Filters
--

--- first part of identifier filter
is_identifier = (c) ->
	c\match "[a-zA-Z_]"

-- second part of identifier filter, picks up 0-9
is_identifier2 = (c) ->
	c\match "[a-zA-Z_0-9]"

is_digit = (c) ->
	c\match "[0-9]"

is_simpleop = (c) ->
	c\match "[%+%*-/]"

-- gets symbol if it exists
getsymbol = (sym, i, s) ->
	idx = i
	otraidx = 1
	buff = ""
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
	while peek(s, idx) ~= nil and f peek s, idx
		buff ..= peek s, idx
		idx += 1
	return buff, idx

-- filter system where only the first character is filtered by f1, all others by f2
matchwhileswitch = (i, s, f1, f2) ->
	idx = i
	buff = ""
	f = f1
	while peek(s, idx) ~= nil and f(peek s, idx) ~= nil
		f = f2 if f == f1
		buff ..= peek s, idx
		idx += 1
	return buff, idx
				
-- gets identifier
getidentifier = (i, s) ->
	t, ni = matchwhileswitch(i, s, is_identifier, is_identifier2)
	if ni ~= i
		token("identifier", t, i), ni

-- gets number
getnumber = (i, s) ->
	t, ni = matchwhile(i, s, is_digit)
	if ni ~= i
		token("number", t, i), ni

-- get op
getop = (i, s) ->
	t, ni = matchwhile(i, s, is_simpleop)
	if ni ~= i
		token("op", t, i), ni

-- gets double colon
getdoublecolon = (i, s) ->
	ni = getsymbol "::", i, s
	if ni
		return token("doublecolon", "::", i), ni

getarrow = (i, s) ->
	ni = getsymbol "->", i, s
	if ni
		return token("arrow", "->", i), ni

getset = (i, s) ->
	ni = getsymbol "=", i, s
	if ni
		return token("set", "=", i), ni

-- gets next token or throws an error if it can't get a sensible next token
nexttoken = (s, i) ->
	if peek(s, i) == nil
		return

	if peek(s, i)\match "[ \t\n]" -- Skip white space and other fluff
		return nexttoken s, i+1

	doublecolon, ni = getdoublecolon i, s
	if doublecolon
		return doublecolon, ni

	identifier, ni = getidentifier i, s
	if identifier
		return identifier, ni

	number, ni = getnumber i, s
	if number
		return number, ni

	set, ni = getset i, s
	if set
		return set, ni

	arrow, ni = getarrow i, s
	if arrow
		return arrow, ni

	op, ni = getop i, s
	if op
		return op, ni

	-- throw error?
	
	if peek(s, i) ~= nil
		lexerr "Unexpected '#{peek(s, i)}'", s, i, peek(s, i)

-- simple lexer that marches nexttoken, TODO
lex = (s) ->
	i = 1
	tok = {}
	while true
		nt, ni = nexttoken s, i
		return tok if not nt or not ni
		print nt.name, ni
		i = ni
		table.insert tok, nt


{:matchwhile, :getidentifier, :nexttoken, :lex}