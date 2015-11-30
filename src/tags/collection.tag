<collection>
  <collection-header/>
  <table class="mui-table mui-table--bordered"> 
    <thead>
      <tr > 
        <th each="{ colkey, colval in rows[0] }" >{ colkey }</th>
      </tr>
    </thead>
    <tbody>
      <tr each="{ row in rows }" > 
        <td each="{ colkey, colval in row }">{ colval }</td>
      </tr> 
    </tbody>
  </table>

  <script>
    self = this
    EL = self.root
    @cols = []
    @rows = []

    @.load =  EL.load = ((newrows) ->
        if newrows == undefined or !newrows.length
          newrows = opts.data
        self.cols = Object.keys(newrows[0])
        self.rows = newrows
        self.update()
        return
      ).bind(this)

    @on 'update', ->
      EL.append = ((newrows) ->
        self.rows.push newrows
        self.update()
        return
      ).bind(this)

      EL.reset = ->
        self.rows = []
        self.update()
        return

      @drawcell = ((rowdata, tr, col) ->
        idx = tr.root.children.length
        #- index of the current painting cell
        if idx == 0
          return
        if self.cols[idx - 1].inner
          tr.root.children[idx - 1].innerHTML = riot.util.tmpl(self.cols[idx - 1].inner, rowdata)
        else
          tr.root.children[idx - 1].innerHTML = rowdata[self.cols[idx - 1].name]
        return
      ).bind(this)
      riot.tag 'rcol', '', (opts) ->
        `var self`
        self = this
        @on 'mount', ->
          self.root.style.display = 'none'
          return
        return
    @.on 'mount', () ->
      @.load()
  </script>
</collection>
