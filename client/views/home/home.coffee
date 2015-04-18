NB_COL_LINE = 10
ARR_COL_LINE = [0...NB_COL_LINE]

Template.home.rendered = ->
  svgWidth = svgHeight = 100
  voronoiData = []
  sqWidth = svgWidth / NB_COL_LINE
  sqHeight = svgHeight / NB_COL_LINE
  for line in ARR_COL_LINE
    for col in ARR_COL_LINE
      voronoiData.push [
        (line + .5) * sqWidth
        (col + .5) * sqHeight
      ]
  vertice = d3.range(100).map (d, i) -> voronoiData[i]
  polygon = (d) -> "M#{d.join 'L'}Z"
  voronoi = d3.geom.voronoi()
    .clipExtent [[0, 0], [svgWidth, svgHeight]]
  svg = d3.select '.svg-content'
    .append 'svg:svg'
      .attr 'preserveAspectRatio', 'xMinYMin meet'
      .attr 'viewBox', "0 0 #{svgWidth} #{svgHeight}"
  path = svg.append 'g'
    .selectAll 'path'
  svg.append 'g'
    .selectAll 'circle'
    .data vertice
    .enter()
    .append 'circle'
      .attr 'transform', (d) -> "translate(#{d.toString()})"
      .attr 'r', 1
  data = path.data (voronoi vertice)
  data
    .enter()
    .append 'path'
    .attr 'd', polygon
    .order()
  data.exit().remove()
  @updateVoronoi = ->
    for line in ARR_COL_LINE
      for col in ARR_COL_LINE
        idx = line * NB_COL_LINE + col
        voronoiData[idx][0] = (line + .5 - .5 * Math.random()) * sqWidth
        voronoiData[idx][1] = (col + .5 - .5 * Math.random()) * sqHeight
    svg.selectAll 'path'
      .data (voronoi vertice)
      .transition()
      .attr 'd', polygon
      .delay (d, i) -> i * 10
    svg.selectAll 'circle'
      .data vertice
      .transition()
      .attr 'transform', (d) -> "translate(#{d.toString()})"
      .delay (d, i) -> i * 10
  @fullscreen = ->
    return screenfull.exit() if screenfull.isFullscreen
    target = (@$ '.svg-content')[0]
    screenfull.request target
  ($ 'body').on 'keydown', (e) =>
    switch e.which
      # Pressing 'f'
      when 70 then @fullscreen()
      # Pressing 'r'
      when 82 then @updateVoronoi()

Template.home.destroyed = -> ($ 'body').off 'keydown'

Template.home.events
  'click button': (e, t) ->
    $button = t.$ e.target
    role = $button.attr 'data-role'
    switch role
      when 'fullscreen' then t.fullscreen()
      when 'random' then t.updateVoronoi()
    $button.addClass 'clicked'
    $button.on ANIMATION_END_EVENT, ->
      $button
        .off ANIMATION_END_EVENT
        .removeClass 'clicked'
