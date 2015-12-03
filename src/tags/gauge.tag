<gauge>      
  <div id="gauge" class="gauge">
    <div id="x" class="gauge-container">
      <div id="a" class="gauge-a"></div>
      <div id="b" class="gauge-b"></div>
      <div id="c" class="gauge-c"></div>
      <div id="data" class="gauge-data"></div>
    </div>
  </div>

  @timeout = 100
  @val = 0
  @valDesired = 0
  @postfix = ""
  @ratio
  @hidevalue = false
  me = @
  
  @.on 'mount', () ->
    @update()

  @getValue = () ->
    ( if not me.hidevalue then Math.round( me.val / me.ratio ) else "" )

  @increase = () ->
    if me.val < me.valDesired 
      me.val += 1
      me.data.innerHTML = me.getValue()+me.postfix
      setTimeout me.increase, me.timeout 
  
  @decrease = () ->
    if me.val > me.valDesired 
      me.val -= 0.5
      me.data.innerHTML = me.getValue()+me.postfix
      setTimeout me.decrease, me.timeout 

  @updateRadius = (percent) ->
    gaugepos = ( 0.5 / 100 ) * percent 
    gaugepos = String(gaugepos).substr(1,2) 
    me.c.style.transform = 'rotate('+gaugepos+'turn)'

  @setSize = (type) ->
    @x.className = "gauge-container-"+type
    @[i].className = "gauge-"+i+"-"+type for i in ["a","b","c"]
    @data.className = "gauge-data-"+type
    @gauge.className = "gauge-"+type

  @.on 'update', () ->
    @ratio = 100 / parseInt(opts.total)
    @valDesired = @ratio * parseInt(opts.value)  
    @postfix = opts.postfix
    @hidevalue = true if opts.hidevalue?
    @setSize opts.type 
    setTimeout @increase, @timeout 
    setTimeout @decrease, @timeout 
    setTimeout () ->
      me.updateRadius me.valDesired
    ,500

</gauge>
