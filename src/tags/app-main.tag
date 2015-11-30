<app-main>
  <div id="content-wrapper">
    <div class="mui--appbar-height"></div>
    <div class="mui-container-fluid" id="content">
      <div class="mui-row">
        <div class="mui-panel">
          <routehandler id="router"></routerhandler>
        </div>
      </div>
    </div>
  </div>

  <script>
    self = this

    @createPageFromCollection = (page) ->
      riot.router page.href, (ctx,next) ->
        self.router._tag.setTag page.tag, {config:opts, page: page} 
        page.data ((data) ->
          riot.mount 'collection', {config:opts, dataoptions: data, data:data.data, page:page}
          riot.mount 'datatable', {id: page.id, options:data.options, data:data.data}
          self.update()
          self.opts.loadingbar.go 100
          next()
          return
        ),
          query: ''
          sort: 'foo'
          order: 'asc'
          limit: 20
          offset: 0
        return
      return

    @getItems = (type) ->
      pages = []
      for i of opts.menu.items
        menuitem = opts.menu.items[i]
        if menuitem.type? and menuitem.type == type
          pages.push menuitem
        if menuitem.items != undefined
          for j of menuitem.items
            subitem = menuitem.items[j]
            if subitem.type? and subitem.type == type
              pages.push subitem
      return pages

    @setupPages = () ->
      pages = @getItems "collection"
      for p in pages
        continue if not p.type?
        ((page) ->
          if page.type is 'collection'
            self.createPageFromCollection page
            console.dir page
        ) p
      return

    self.title = ''
    self.body = ''
    @on 'mount', () ->
      riot.mount 'routehandler', opts
      riot.router = @router._tag.page
      self.setupPages()
      return
  </script>

</app-main>

