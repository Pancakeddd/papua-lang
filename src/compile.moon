import envvardefine, checkenv from require 'env'

compilerr = (str) ->
  error "Compile Error: #{str}"

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

compileset = (a, env, l="local") ->
  if v2 = compilevalue a.value2, env
    return "#{l or ""} #{a.value1.value} = #{v2}"
  else
    compilerr "Couldn't find "

compiledefine = (a, env) ->
  s = a.type.setname.value
  if not env[s]
    envvardefine env, s, a.type.value
  else
    compilerr "Expected definition of #{a.type.setname.value} to not exist"
  return "#{compileset a.set, env}"

compile = (a, env) ->
  switch a.name
    when "set"
      return compileset a, env
    when "define"
      compiledefine a, env

{:compile}