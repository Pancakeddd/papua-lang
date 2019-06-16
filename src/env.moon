env = ->
  {
    varenv: {}
  }

checkenv = (env, name) ->
  env[name]

envvardefine = (env, name, type) ->
  env[name] = {
    :type
  }

{:env, :envvardefine, :checkenv}