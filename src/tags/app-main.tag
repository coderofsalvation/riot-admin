<app-main>
  <div id="content-wrapper">
    <div class="mui--appbar-height"></div>
    <div class="mui-container-fluid" id="content">
      <div class="mui-row">
        <div class="mui-panel">
          <h1 if={ title }>{ title }</h1>
          <p>
            { body }
            <collection id="collection"/>
          </p>
        </div>
      </div>
    </div>
  </div>

  <script>
    var self = this

    self.title = ''
    self.body = ''

    function createPageFromLink(r,page){
      if( page.target != undefined ) return;
      r( page.href, function(){
        $('#content').addClass("fadeout").removeClass("fadein");
        setTimeout( function(){
          collection.reset()
          self.update({
            title:  page.label,
            body:  "",
            isFirst: false
          });
          $('#content').addClass("fadein").removeClass("fadeout");
        },400);
      });
    }

    function createPageFromCollection(r,page){
      r( page.href, function(){
        $('#content').addClass("fadeout").removeClass("fadein");
        setTimeout( function(){
          self.update({
            title: " ",
            body:  "",
            isFirst: false
          });
          page.data( function(data){ 
              self.collection.load( data.data );
              self.title = data.title;
              self.update();
              $('#content').addClass("fadein").removeClass("fadeout");
            }, 
            {query:"", sort:'foo',order:'asc',limit:20,offset:0} 
          )
        },400);
      });
    }
  
    function setupPages(){
      var r = riot.route.create()
      var pages = [];
      for( i in opts.menu.items ){
        menuitem = opts.menu.items[i]
        if( menuitem.type != "link" && menuitem.type != "submenu" ) pages.push( menuitem );
        if( menuitem.items != undefined ){
          for( j in menuitem.items ){
            subitem = menuitem.items[j]
            if( menuitem.type != "link" ) pages.push( subitem );
          }
        }
      }
      for( k in pages ){
        var p = pages[k];
        ( function(page){
            switch( page.type ){
              case "collection": createPageFromCollection(r,page);                     break;
              case "link":       createPageFromLink(r,page);                           break;
              default:           console.log("unknown page type in menu:"+page.type);  break;
            }
          }
        )(p);
      }
    }

    this.on('mount',function(){
      setupPages();
    });
  </script>

</app-main>

