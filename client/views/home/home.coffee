NB_COL_LINE = 10
ARR_COL_LINE = [0...NB_COL_LINE]

Template.home.rendered = ->
  console.log 'Home rendered'
  svgWidth = svgHeight = 100
  voronoiData = []
  for line in ARR_COL_LINE
    for col in ARR_COL_LINE
      voronoiData.push [
        (line + .5) * svgWidth / NB_COL_LINE
        (col + .5) * svgHeight / NB_COL_LINE
      ]

  vertice = d3.range(100).map (d, i) -> voronoiData[i]

  polygon = (d) -> "M#{d.join 'L'}Z"

  voronoi = d3.geom.voronoi()
    .clipExtent [[0, 0], [svgWidth, svgHeight]]

  svg = d3.select '.svg-content'
    .append 'svg:svg'
      .attr 'preserveAspectRatio', 'xMinYMin meet'
      .attr 'viewBox', "0 0 #{svgWidth} #{svgHeight}"

  path = svg
    .append 'g'
    .selectAll 'path'
    .data (voronoi vertice)
    .enter()
      .append 'path'
      .attr 'd', polygon
      .order()

  svg.selectAll 'circle'
    .data vertice
    .enter()
    .append 'circle'
      .attr 'transform', (d) -> "translate(#{d.toString()})"
      .attr 'r', 1

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
