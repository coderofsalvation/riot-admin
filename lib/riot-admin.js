// Generated by CoffeeScript 1.9.3
(function() {
  var nanobar, riotadmin, routehandler, typesafe, typeshave;

  nanobar = require('nanobar');

  routehandler = require('riot-routehandler');

  require('notification-fallback');

  typeshave = require('typeshave');

  typeshave.verbose = 1;

  typesafe = typeshave.typesafe;

  riotadmin = {
    listeners: {}
  };

  riotadmin.on = function(event, listener) {
    if (riotadmin.listeners[event] == null) {
      riotadmin.listeners[event] = [];
    }
    return riotadmin.listeners[event].push(listener);
  };

  riotadmin.trigger = function(event, data) {
    var i, len, listener, ref, results;
    if (riotadmin.listeners[event] != null) {
      ref = riotadmin.listeners[event];
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        listener = ref[i];
        results.push(listener(data));
      }
      return results;
    }
  };

  riotadmin.init = typesafe({
    'type': 'object',
    'properties': {
      'project': {
        'type': 'object',
        'required': true,
        'properties': {
          'title': {
            'type': 'string',
            'required': true
          },
          'url': {
            'type': 'string',
            'required': true
          }
        }
      },
      'footer': {
        'type': 'object',
        'required': true,
        'properties': {
          'slogan': {
            'type': 'string',
            'required': true
          }
        }
      }
    }
  }, function(config) {
    riot.compile(function() {
      var $bodyEl, $sidedrawerEl;
      window.loadingbar = config.loadingbar = new nanobar({
        bg: '#333'
      });

      /*
       * utility prototype functions  etc
       */
      window.$_ = document.querySelector.bind(document);
      window.$$_ = document.querySelectorAll.bind(document);
      Element.prototype.hasClass = function(className) {
        return new RegExp('(\\s|^)' + className + '(\\s|$)').test(this.getAttribute('class'));
      };
      Element.prototype.addClass = function(className) {
        if (!this.hasClass(className)) {
          this.setAttribute('class', this.getAttribute('class') + ' ' + className);
        }
        return this;
      };
      Element.prototype.removeClass = function(className) {
        var removedClass;
        removedClass = this.getAttribute('class').replace(new RegExp('(\\s|^)' + className + '(\\s|$)', 'g'), '$2');
        if (this.hasClass(className)) {
          this.setAttribute('class', removedClass);
        }
        return this;
      };
      Element.prototype.toggleClass = function(className) {
        if (this.hasClass(className)) {
          this.removeClass(className);
        } else {
          this.addClass(className);
        }
        return this;
      };
      Element.prototype.appendTo = function(el, move) {
        el.innerHTML = el.innerHTML + this.innerHTML;
        if (move) {
          this.innerHTML = "";
        }
      };
      Element.prototype.hide = function() {
        this.style.display = 'none';
      };

      /*
       * set page transition
       */
      config.routes.unshift({
        route: '*',
        use: function(ctx, next, page) {
          console.dir(ctx);
          if (window.url !== ctx.canonicalPath) {
            window.url = ctx.canonicalPath;
            $_('#content').addClass('fadeout').removeClass('fadein');
            return setTimeout(function() {
              $_('#content').addClass('fadein').removeClass('fadeout');
              window.loadingbar.go(100);
              return next();
            }, 400);
          } else {
            return next();
          }
        }
      });
      console.dir(config.routes);

      /*
       * mount the tags
       */
      this.tags = riot.mount('*', config);

      /*
       * setup events
       */
      $bodyEl = $_('body');
      $sidedrawerEl = $_('#sidedrawer');
      if (!$_('.js-show-sidedrawer')) {
        console.error('sidedrawer menu not loaded..tags loaded properly?');
      }
      $_('.js-show-sidedrawer').addEventListener('click', $_('app-sidemenu')._tag.toggle);
      $_('#sidedrawer-toggler-xs').addEventListener('click', $_('app-sidemenu')._tag.toggle);
      $_('#content').addClass('fadein');
      setTimeout(function() {
        return Notification.requestPermission();
      }, 20000);
    });
  });

  if (typeof window !== "undefined" && window !== null) {
    window.riotadmin = riotadmin;
  }

}).call(this);