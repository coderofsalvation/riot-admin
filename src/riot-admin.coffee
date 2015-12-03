nanobar      = require 'nanobar'
routehandler = require 'riot-routehandler'
require 'notification-fallback'

typeshave = require('typeshave')
typeshave.verbose = 1
typesafe = typeshave.typesafe

riotadmin = 
  listeners: {}

riotadmin.on = (event,listener) ->
  if not riotadmin.listeners[event]?
    riotadmin.listeners[event] = []
  riotadmin.listeners[event].push listener

riotadmin.trigger = (event,data) ->
  if riotadmin.listeners[event]?
    listener(data) for listener in riotadmin.listeners[event]

riotadmin.init = typesafe
  'type': 'object'
  'properties':
    'project':
      'type': 'object'
      'required': true
      'properties':
        'title':
          'type': 'string'
          'required': true
        'url':
          'type': 'string'
          'required': true
    'footer':
      'type': 'object'
      'required': true
      'properties': 'slogan':
        'type': 'string'
        'required': true
, (config) ->
  riot.compile ->
    window.loadingbar = config.loadingbar = new nanobar({bg: '#333'})
    #riot.route.base '/'
    #riot.route.start true
    
    ###
    # utility prototype functions  etc
    ###
    window.$_ = document.querySelector.bind(document)
    window.$$_ = document.querySelectorAll.bind(document)

    Element::hasClass = (className) ->
      new RegExp('(\\s|^)' + className + '(\\s|$)').test @getAttribute('class')

    Element::addClass = (className) ->
      if !@hasClass(className)
        @setAttribute 'class', @getAttribute('class') + ' ' + className
      this

    Element::removeClass = (className) ->
      removedClass = @getAttribute('class').replace(new RegExp('(\\s|^)' + className + '(\\s|$)', 'g'), '$2')
      if @hasClass(className)
        @setAttribute 'class', removedClass
      this

    Element::toggleClass = (className) ->
      if @hasClass(className)
        @removeClass className
      else
        @addClass className
      this

    Element::appendTo = (el,move) ->
      el.innerHTML = el.innerHTML + @innerHTML
      @innerHTML = "" if move
      return

    Element::hide = ->
      @style.display = 'none'
      return

    ###
    # set page transition
    ###
    #
    config.routeroptions.pagehandlers = 
      '*': (ctx,next) ->
        console.dir ctx
        if window.url != ctx.canonicalPath 
          window.url = ctx.canonicalPath
          $_('#content').addClass('fadeout').removeClass('fadein')
          setTimeout () ->
            riotadmin.trigger window.url 
            $_('#content').addClass('fadein').removeClass('fadeout')
            window.loadingbar.go 100
            next();
          ,400
        else next();
    ###
    # mount the tags
    ###
    @tags = riot.mount('*', config)

    ###
    # setup events 
    ###
    $bodyEl = $_('body')
    $sidedrawerEl = $_('#sidedrawer')
    if !$_('.js-show-sidedrawer')
      console.error 'sidedrawer menu not loaded..tags loaded properly?'

    $_('.js-show-sidedrawer').addEventListener 'click', $_('app-sidemenu')._tag.toggle
    $_('#sidedrawer-toggler-xs').addEventListener 'click', $_('app-sidemenu')._tag.toggle
    $_('#content').addClass 'fadein'
    
    setTimeout () ->
      Notification.requestPermission()
    ,20000
    return
  return

window.riotadmin = riotadmin if window?
