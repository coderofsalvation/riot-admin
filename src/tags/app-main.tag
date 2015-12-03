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
    jfn = require 'jsonschema2form-nested'
    require('jsonschema2form-nested/themes/mui.js')(jfn)

    @createPageFromCollection = (page,opts) ->
      console.log "create collection"
      opts.routes.push 
        route: page.href
        use: (ctx,next) ->
          self.router._tag.setTag page.tag, {config:opts, page: page} 
          page.data ((data) ->
            riot.mount 'collection', {id: page.id, config:opts, dataoptions: data, data:data.data, page:page}
            riot.mount 'datatable', {id: page.id, options:data.options, data:data.data}
            if page.edit?.schema?
              i = 0 # register clicks if any
              for row in $$_('#'+page.id+' tbody tr')
                row.addEventListener 'click', ( (dataitem) ->
                  (e) ->
                    html = '''
                      <div class="mui-row">
                        <form id='form'></form>
                      </div>
                      <div class="mui-row">
                        <div class="mui-col-md-12">
                          <button type='submit' id="formsubmit" class='mui-btn mui-btn--raised'>Save</button>
                    '''
                    html += "<button type='submit' id='formdelete' class='mui-btn mui-btn--raised'>Delete</button>" if dataitem.id?
                    html += '</div></div>'
                    $_("#edit")._tag.show page.edit.schema.title, html
                    jfn.render 
                      element: $_("#form")
                      data: dataitem
                      schema: page.edit.schema
                    $_("#formsubmit").addEventListener 'click', () ->
                      self.opts.loadingbar.go 50
                      page.edit.onSave jfn.toJSON( $_("#form") ), (succes,msg) ->
                        self.opts.loadingbar.go 100
                        $_("#edit")._tag.hide()
                        n = new Notification msg 
                        n.leaveAfter(2000, n);
                )(data.data[i++])
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

    @setupPages = (opts) ->
      pages = @getItems "collection"
      for p in pages
        continue if not p.type?
        ((page) ->
          self.createPageFromCollection page, opts if page.type is 'collection'
        ) p
      return

    self.title = ''
    self.body = ''
    @on 'mount', () ->
      self.setupPages(opts)
      riot.mount 'routehandler', opts
      riot.router = @router._tag.page
      return
  </script>

</app-main>

