$(document).on 'page:change', ->
  $chart = $('#chart')
  return if $chart.length == 0

  categories = []
  data = []
  curDate = moment().subtract('days', 30)
  trends = $chart.data('trends')
  word = $chart.data('word')

  for i in [1...30]
    strDate = curDate.format('YYYY-MM-DD')
    categories.push curDate.format('MM-DD')
    if trends[strDate]
      data.push trends[strDate]
    else
      data.push 0
    curDate.add('days', 1)

  $chart.highcharts
    credits:
      enabled: false
    title:
      text: 'How many times a word appears'
    subtitle:
      text: 'in last 30 days'
    xAxis:
      categories: categories
    yAxis:
      title:
        text: 'occurs'
    series: [
      {
        name: word
        data: data
      }
    ]
