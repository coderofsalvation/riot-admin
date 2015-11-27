riot.tag('app-footer', '<footer id="footer"> <div class="mui-container-fluid"> <br> <raw content="{ opts.footer.slogan }"></raw> </div> </footer>', function(opts) {

});


riot.tag('app-header', '<header id="header"> <div class="mui-appbar mui--appbar-line-height"> <div class="mui-container-fluid"> <a id="sidedrawer-toggler" class="sidedrawer-toggle mui--hidden-xs js-show-sidedrawer">☰</a> <a id="sidedrawer-toggler-xs" class="sidedrawer-toggle mui--visible-xs-inline-block js-show-sidedrawer">☰</a> <span class="mui--text-title mui--visible-xs-inline-block"><i class="fa { opts.project.icon }"></i>{ opts.project.title }</span> </div> </header>', function(opts) {

});

riot.tag('app-main', '<div id="content-wrapper"> <div class="mui--appbar-height"></div> <div class="mui-container-fluid" id="content"> <div class="mui-row"> <div class="mui-panel"> <routehandler></routehandler> </div> </div> </div> </div>', function(opts) {var createPageFromCollection, createPageFromLink, self, setupPages;

self = this;

createPageFromLink = function(r, page) {
  if (page.target !== void 0) {
    return;
  }
  r(page.href, function() {
    $('#content').addClass('fadeout').removeClass('fadein');
    self.opts.loadingbar.go(50);
    setTimeout((function() {
      collection.reset();
      self.update({
        title: page.label,
        body: '',
        isFirst: false
      });
      $('#content').addClass('fadein').removeClass('fadeout');
      self.opts.loadingbar.go(100);
    }), 400);
  });
};

createPageFromCollection = function(r, page) {
  r(page.href, function() {
    $('#content').addClass('fadeout').removeClass('fadein');
    self.opts.loadingbar.go(50);
    setTimeout((function() {
      self.update({
        title: ' ',
        body: '',
        isFirst: false
      });
      page.data((function(data) {
        self.collection.load(data.data);
        self.title = data.title;
        self.update();
        $('#content').addClass('fadein').removeClass('fadeout');
        self.opts.loadingbar.go(100);
      }), {
        query: '',
        sort: 'foo',
        order: 'asc',
        limit: 20,
        offset: 0
      });
    }), 400);
  });
};

setupPages = function() {
  var fn, i, j, k, menuitem, p, pages, r, subitem;
  r = riot.route.create();
  pages = [];
  for (i in opts.menu.items) {
    i = i;
    menuitem = opts.menu.items[i];
    if (menuitem.type !== 'link' && menuitem.type !== 'submenu') {
      pages.push(menuitem);
    }
    if (menuitem.items !== void 0) {
      for (j in menuitem.items) {
        j = j;
        subitem = menuitem.items[j];
        if (menuitem.type !== 'link') {
          pages.push(subitem);
        }
      }
    }
  }
  fn = function(page) {
    switch (page.type) {
      case 'collection':
        createPageFromCollection(r, page);
        break;
      case 'link':
        createPageFromLink(r, page);
        break;
      default:
        console.log('unknown page type in menu:' + page.type);
        break;
    }
  };
  for (k in pages) {
    k = k;
    p = pages[k];
    fn(p);
  }
};

self.title = '';

self.body = '';

this.on('mount', function() {});

});


riot.tag('app-sidemenu', '<div id="sidedrawer" class="mui--no-user-select"> <div id="sidedrawer-brand" class="mui--appbar-line-height mui--text-title"><raw content="{ opts.project.logo }"></raw>{ opts.project.title }</div> <div class="mui-divider"></div> <ul each="{ opts.menu.items }"> <li> <strong if="{ type == \'submenu\' }" onclick="{ expandsub }"><raw if="{ icon }" content="{ icon }"></raw>{ label }</strong> <strong if="{ type != \'submenu\' }"><a href="{href}" target="{ target }"><raw if="{ icon }" content="{ icon }"></raw>{ label }</a></strong> <ul > <li each="{ items }" > <a href="{href}" target="{ target }">{ label }</a></li> </li> </ul> </li> </ul> </div>', function(opts) {var expandsub, hide, toggle;

expandsub = function(el) {
  if (el.target.parentElement.children[1] !== void 0) {
    el.target.parentElement.children[1].toggleClass('expand');
  }
};

hide = function() {
  this.sidedrawer.removeClass('active');
  document.body.removeClass('hide-sidedrawer');
};

toggle = function() {
  this.sidedrawer.toggleClass('active');
  document.body.toggleClass('hide-sidedrawer');
};

});


riot.tag('collection', '<collection-header></collection-header> <table class="mui-table mui-table--bordered"> <thead> <tr > <th each="{ colkey, colval in rows[0] }" >{ colkey }</th> </tr> </thead> <tbody> <tr each="{ row in rows }" > <td each="{ colkey, colval in row }">{ colval }</td> </tr> </tbody> </table>', function(opts) {var EL, self;

self = this;

EL = self.root;

this.cols = [];

this.rows = [];

this.on('update', function() {});

EL.load = (function(newrows) {
  if (newrows === void 0 || !newrows.length) {
    return;
  }
  self.cols = Object.keys(newrows[0]);
  self.rows = newrows;
  self.update();
}).bind(this);

EL.append = (function(newrows) {
  self.rows.push(newrows);
  self.update();
}).bind(this);

EL.reset = function() {
  self.rows = [];
  self.update();
};

this.drawcell = (function(rowdata, tr, col) {
  var idx;
  idx = tr.root.children.length;
  if (idx === 0) {
    return;
  }
  if (self.cols[idx - 1].inner) {
    tr.root.children[idx - 1].innerHTML = riot.util.tmpl(self.cols[idx - 1].inner, rowdata);
  } else {
    tr.root.children[idx - 1].innerHTML = rowdata[self.cols[idx - 1].name];
  }
}).bind(this);

riot.tag('rcol', '', function(opts) {
  var self;
  self = this;
  this.on('mount', function() {
    self.root.style.display = 'none';
  });
});

});

riot.tag('raw', '<span></span>', function(opts) {this.root.innerHTML = opts.content;

});
