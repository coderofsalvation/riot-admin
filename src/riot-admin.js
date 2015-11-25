typeshave         = require("typeshave");
typeshave.verbose = 1
typesafe          = typeshave.typesafe;

riotadmin = typesafe (
  {
    "type":"object",
    "properties":{
      "project": {
        "type": "object",
        "required": true,
        "properties":{
          "title": { "type":"string", "required":true },
          "url": { "type":"string", "required":true }
        }
      },
      "footer": {
        "type": "object",
        "required": true,
        "properties":{
          "slogan": { "type":"string", "required":true },
        }
      }
    }
  }, function(config){
    riot.compile(function() {
      riot.route.base('/')
      this.tags = riot.mount('*', config )
      riot.route.start(true)

      // util functions 
      window.$ = document.querySelector.bind(document);
      window.$$ = document.querySelectorAll.bind(document);

      Element.prototype.hasClass = function (className) {
        return new RegExp('(\\s|^)' + className + '(\\s|$)').test(this.getAttribute('class'));
      };

      Element.prototype.addClass = function (className) {
        if (!this.hasClass(className)) 
          this.setAttribute('class', this.getAttribute('class') + ' ' + className);
        return this;
      };

      Element.prototype.removeClass = function (className) {
        var removedClass = this.getAttribute('class').replace(new RegExp('(\\s|^)' + className + '(\\s|$)', 'g'), '$2');
        if (this.hasClass(className)) this.setAttribute('class', removedClass);
        return this;
      };

      Element.prototype.toggleClass = function (className) {
        if (this.hasClass(className)) this.removeClass(className);
        else this.addClass(className);
        return this;
      };

      Element.prototype.appendTo = function(el) {
        el.innerHTML = el.innerHTML + this.innerHTML;
      }

      Element.prototype.hide = function(){
        this.style.display = "none";
      }
     
      var $bodyEl = $('body'),
      $sidedrawerEl = $('#sidedrawer');

      if( ! $('.js-show-sidedrawer') ) console.error("sidedrawer menu not loaded..tags loaded properly?");
      $('.js-show-sidedrawer').addEventListener( "click", $("app-sidemenu")._tag.toggle );
      $('#sidedrawer-toggler-xs').addEventListener( "click", $("app-sidemenu")._tag.toggle );
      $('#content').addClass("fadein");
    })
  }
);
