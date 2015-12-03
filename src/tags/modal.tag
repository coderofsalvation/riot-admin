<app-modal>
  <div id="content" style="display:none">
    <div class="mui-container">
      <div class="mui-row">
        <div class="mui-col-md-12">
          <h1>{ this.title }</h1>
        </div>
      </div>
      <raw content={ html }/>
    </div>
  </div>

  <script>
    @overlay
    @title
    @html

    @show = (title,html) ->
      @overlay.style.width = '80%';
      #@overlay.style.height = '80%';
      @overlay.style.margin = '5% auto';
      @overlay.style.backgroundColor = '#fff';
      @title = title
      @html = html
      @update()
      @content.appendTo @overlay, true
      mui.overlay('on', @overlay );
    
    @hide = () ->
      mui.overlay('off', @overlay );

    @on 'mount', () ->
      @overlay = document.createElement('div');
  </script>
</app-modal>
