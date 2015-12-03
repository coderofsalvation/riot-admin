<gauge>      
  <div id="x" class="gauge-container">
    <div id="a" class="gauge-a"></div>
    <div id="b" class="gauge-b"></div>
    <div id="c" class="gauge-c"></div>
    <div id="data" class="gauge-data">
    </div>
  </div>

  @val = 0
  @valDesired = 0
  @postfix = ""
  @ratio
  me = @
  
  @.on 'mount', () ->
    @update()

  @increase = () ->
    if me.val < me.valDesired 
      me.val += 1
      me.data.innerHTML = Math.round( me.val / me.ratio )+me.postfix
      me.increase()
  
  @decrease = () ->
    if me.val > me.valDesired 
      me.val -= -
      me.data.innerHTML = Math.round( me.val / me.ratio )+me.postfix
      me.increase()

  @updateRadius = (percent) ->
    gaugepos = ( 0.5 / 100 ) * percent 
    gaugepos = String(gaugepos).substr(1,2) 
    console.log "setting position to "+percent+ " -> "+gaugepos
    me.c.style.transform = 'rotate('+gaugepos+'turn)'

  @setSize = (type) ->
    @x.className = "gauge-container-"+type
    @[i].className = "gauge-"+i+"-"+type for i in ["a","b","c"]
    @data.className = "gauge-data-"+type

  @.on 'update', () ->
    @ratio = 100 / parseInt(opts.total)
    @valDesired = @ratio * parseInt(opts.value)  
    @postfix = opts.postfix
    @setSize opts.type 
    setTimeout @increase, 100
    setTimeout @decrease, 100
    setTimeout () ->
      me.updateRadius me.valDesired
    ,500

</gauge>
