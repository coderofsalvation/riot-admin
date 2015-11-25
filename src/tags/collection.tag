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
    var self = this
    var EL = self.root
    this.cols = []
    this.rows = []
    
    this.on('update', function() {
      
    })

    EL.load= function(newrows){
      if( newrows == undefined || ! newrows.length ) return ;
      self.cols = Object.keys(newrows[0]);
      self.rows=newrows
      self.update()
    }.bind(this);

    EL.append= function(newrows){
      self.rows.push(newrows)
      self.update()
    }.bind(this);

    EL.reset = function(){
      self.rows = []
      self.update()
    }

     
    this.drawcell = function(rowdata, tr,  col) {
      var idx = tr.root.children.length  //- index of the current painting cell
      if(idx==0) return;
      if( self.cols[idx-1].inner){
        tr.root.children[idx-1].innerHTML=riot.util.tmpl( self.cols[idx-1].inner ,  rowdata )
      }else{
        tr.root.children[idx-1].innerHTML=rowdata[self.cols[idx-1].name ]
      }
    }.bind(this);

    riot.tag('rcol', '', function(opts) {
      var self = this
      this.on('mount', function(){ self.root.style.display='none'; })
    });

  </script>
</collection>
