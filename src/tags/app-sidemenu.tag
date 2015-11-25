<app-sidemenu>

  <div id="sidedrawer" class="mui--no-user-select">
    <div id="sidedrawer-brand" class="mui--appbar-line-height mui--text-title"><raw content={ opts.project.logo }/>{ opts.project.title }</div>
    <div class="mui-divider"></div>
    <ul each={ opts.menu.items }>
      <li>
        <strong if={ type == 'submenu' } onclick={ expandsub }><raw if={ icon } content={ icon }/>{ label }</strong>
        <strong if={ type != 'submenu' }><a href="{href}" target="{ target }"><raw if={ icon } content={ icon }/>{ label }</a></strong>
        <ul >
          <li each={ items } >
            <a href="{href}" target="{ target }">{ label }</a></li>
          </li>
        </ul>
      </li>
    </ul>
  </div>

  <script>

    expandsub(el) {
      if( el.target.parentElement.children[1] != undefined )
        el.target.parentElement.children[1].toggleClass("expand");
    }

    hide() {
      this.sidedrawer.removeClass("active");  
      document.body.removeClass('hide-sidedrawer');
    }

    toggle() {
      this.sidedrawer.toggleClass("active");  
      document.body.toggleClass('hide-sidedrawer');
    }

  </script>

</app-sidemenu>

