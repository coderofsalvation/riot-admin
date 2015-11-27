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

    createPageFromLink = (r, page) ->
      if page.target != undefined
        return
      r page.href, ->
        $('#content').addClass('fadeout').removeClass 'fadein'
        self.opts.loadingbar.go 50
        setTimeout (->
          collection.reset()
          self.update
            title: page.label
            body: ''
            isFirst: false
          $('#content').addClass('fadein').removeClass 'fadeout'
          self.opts.loadingbar.go 100
          return
        ), 400
        return
      return

    createPageFromCollection = (r, page) ->
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

    setupPages = ->
      r = riot.route.create()
      pages = []
      for i of opts.menu.items
        `i = i`
        menuitem = opts.menu.items[i]
        if menuitem.type != 'link' and menuitem.type != 'submenu'
          pages.push menuitem
        if menuitem.items != undefined
          for j of menuitem.items
            `j = j`
            subitem = menuitem.items[j]
            if menuitem.type != 'link'
              pages.push subitem
      for k of pages
        `k = k`
        p = pages[k]
        ((page) ->
          switch page.type
            when 'collection'
              createPageFromCollection r, page
            when 'link'
              createPageFromLink r, page
            else
              console.log 'unknown page type in menu:' + page.type
              break
          return
        ) p
      return

    self.title = ''
    self.body = ''
    @on 'mount', ->
      #setupPages()
      return
  </script>

</app-main>

