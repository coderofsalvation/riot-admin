<app-main>
  <div id="content-wrapper">
    <div class="mui--appbar-height"></div>
    <div class="mui-container-fluid" id="content">
      <div class="mui-row">
        <div class="mui-panel">
          <routehandler></routehandler>
        </div>
      </div>
    </div>
  </div>

  <script>
    self = this

    createPageFromLink = (config,page) ->
      return if page.target != undefined or not page.tag? or not page.route?
      config.routes.push { route: page.route, tag: page.tag }
      #r page.href, ->
      #  $('#content').addClass('fadeout').removeClass 'fadein'
      #  self.opts.loadingbar.go 50
      #  setTimeout (->
      #    collection.reset()
      #    self.update
      #      title: page.label
      #      body: ''
      #      isFirst: false
      #    $('#content').addClass('fadein').removeClass 'fadeout'
      #    self.opts.loadingbar.go 100
      #    return
      #  ), 400
      #  return
      return

    createPageFromCollection = (r, page) ->
      return
      r page.href, ->
        $('#content').addClass('fadeout').removeClass 'fadein'
        self.opts.loadingbar.go 50
        setTimeout (->
          self.update
            title: ' '
            body: ''
            isFirst: false
          page.data ((data) ->
            self.collection.load data.data
            self.title = data.title
            self.update()
            $('#content').addClass('fadein').removeClass 'fadeout'
            self.opts.loadingbar.go 100
            return
          ),
            query: ''
            sort: 'foo'
            order: 'asc'
            limit: 20
            offset: 0
          return
        ), 400
        return
      return

    @setupPages = (config) ->
      pages = []
      for i of opts.menu.items
        menuitem = opts.menu.items[i]
        if menuitem.tag?
          pages.push menuitem
        if menuitem.items != undefined
          for j of menuitem.items
            subitem = menuitem.items[j]
            if subitem.tag?
              pages.push subitem
      for k of pages
        p = pages[k]
        continue if not p.type?
        ((page) ->
          console.dir page
          switch page.type
            when 'collection'
              console.log "todo: collection" #createPageFromCollection r, page
            when 'link'
              createPageFromLink config, page
            else
              console.log 'unknown page type in menu:' + page.type
              break
          return
        ) p
      return

    self.title = ''
    self.body = ''
    @on 'mount', () =>
      #@setupPages(config)

      return
  </script>

</app-main>

