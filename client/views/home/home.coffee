NB_COL_LINE = 10
ARR_COL_LINE = [0...NB_COL_LINE]

Template.home.rendered = ->
  console.log 'Home rendered'
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
  # svg.selectAll 'circle'
  #   .data vertice
  #   .enter()
  #   .append 'circle'
  #     .attr 'transform', (d) -> "translate(#{d.toString()})"
  #     .attr 'r', 1
  data = path.data (voronoi vertice)
  data
    .enter()
    .append 'path'
    .attr 'd', polygon
    .order()
  data.exit().remove()
  console.log path
  @updateVoronoi = ->
    for line in ARR_COL_LINE
      for col in ARR_COL_LINE
        idx = line * NB_COL_LINE + col
        voronoiData[idx][0] = (line + .1 * Math.random()) * sqWidth
        voronoiData[idx][1] = (col + .1 * Math.random()) * sqHeight
    svg.selectAll 'path'
      .data (voronoi vertice)
      .transition()
      .duration 500
      .delay (d, i) -> i * .3
      .attr 'd', polygon

Template.home.events
  'click button': (e, t) ->
    $button = t.$ e.target
    role = $button.attr 'data-role'
    $button.addClass 'clicked'
    $button.on ANIMATION_END_EVENT, ->
      $button
        .off ANIMATION_END_EVENT
        .removeClass 'clicked'
        console.log 'Role', role
        t.updateVoronoi()
