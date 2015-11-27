test = require('tape')

dotests = () ->
  test 'timing test', (t) ->
    t.plan 2
    t.equal typeof Date.now, 'function'
    start = Date.now()
    setTimeout (->
      t.equal Date.now() - start, 100
      return
    ), 100
    return

dotests() if not window?

