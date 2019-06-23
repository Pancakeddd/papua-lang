import envvardefine, checkenv from require 'env'

compilerr = (str) ->
  error "Compile Error: #{str}"

pprint = require 'pprint'


compilevalue = (a, env, find=true) ->
  switch a.name
    when "identifier"
      if find
        if v2 = checkenv(env, a.value)
          return a.value
        else
          compilerr "Couldn't find '#{a.value}' in environment"
      else
        return a.value
    when "number"
      return a.value

args = (a) ->
  s = ""
  docomma = true
  for v in *a
    if docomma
      s ..= v
      docomma = false
    else
      s ..= ", #{v}"
  return s

compileset = (a, env, l="local") ->
  if v2 = compile a.value2, env
    return "#{l or ""} #{a.value1.value} = #{v2}"

compilesetf = (a, env, l="local", ca) ->
  pprint ca
  print "gaew"
  for x in *a.value1args
    envvardefine env, x.value, "auto"
  return "#{l or ""} #{a.value1.value} = function(#{args(ca)})\n#{compilem a.value2, env}end"

compiledefine = (a, env) ->
  s = a.type.setname.value
  if not env[s]
    envvardefine env, s, a.type.value
  else
    compilerr "Expected definition of #{a.type.setname.value} to not exist"
  --pprint "ge", a.set.value1args[1], [compile x, env for x in *a.set.value1args]
  return compile a.set, env

export compile = (a, env) ->
  switch a.name
    when "set"
      return compileset a, env
    when "setf"
      pprint "araerearae", a.value1args
      return compilesetf a, env, nil, [compile x, env for x in *a.value1args]
    when "identifier"
      return a.value
    when "op"
      return "#{compile a.value1, env} #{a.op} #{compile a.value2, env}"
    when "return"
      return "return #{compile a.value, env}"
    when "define"
      compiledefine a, env

export compilem = (a, env) ->
  s = ""
  for ast in *a
    s ..= "#{compile ast, env}\n"
  return s

{:compile, :compilem}