nanobar      = require 'nanobar'
routehandler = require 'riot-routehandler'

typeshave = require('typeshave')
typeshave.verbose = 1
typesafe = typeshave.typesafe


riotadmin = typesafe({
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
}, (config) ->
  riot.compile ->
    window.loadingbar = config.loadingbar = new nanobar({bg: '#333'})
    #riot.route.base '/'
    #riot.route.start true
    
    ###
    # utility prototype functions  etc
    ###
    window.$ = document.querySelector.bind(document)
    window.$$ = document.querySelectorAll.bind(document)

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

    Element::appendTo = (el) ->
      el.innerHTML = el.innerHTML + @innerHTML
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
        if window.url != ctx.canonicalPath 
          window.url = ctx.canonicalPath
          $('#content').addClass('fadeout').removeClass('fadein')
          setTimeout () ->
            $('#content').addClass('fadein').removeClass('fadeout')
            window.loadingbar.go 100
            next();
          ,400
        else next();
    ###
    # mount the tags
    ###
    @tags = riot.mount('*', config)
    rh = riot.mount 'routehandler', config 

    ###
    # setup events 
    ###
    $bodyEl = $('body')
    $sidedrawerEl = $('#sidedrawer')
    if !$('.js-show-sidedrawer')
      console.error 'sidedrawer menu not loaded..tags loaded properly?'

    $('.js-show-sidedrawer').addEventListener 'click', $('app-sidemenu')._tag.toggle
    $('#sidedrawer-toggler-xs').addEventListener 'click', $('app-sidemenu')._tag.toggle
    $('#content').addClass 'fadein'
    
    return
  return
)


window.riotadmin = riotadmin if window?
