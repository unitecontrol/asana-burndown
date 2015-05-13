$ ->
	return if not projectID

	$.getJSON "/durations/#{projectID}", (result)->
		durations = result.durations
		data = [ new Array(durations.length), new Array(durations.length) ]

		for info, index in durations
			date = new Date(info.date).getTime()
			data[0][index] = [date, info.completedHours]
			data[1][index] = [date, info.unCompletedHours]

		$('#container').highcharts
			chart:
				type:	'area'

			title:
				text:	"Burn down chart [#{result.name}]"

			xAxis:
				type: 'datetime'
				tickmarkPlacement: 'on'
				title:
					enabled: false

			yAxis:
				title:
					text: 'Sum of durations'

			tooltip:
				shared: true

			plotOptions:
				area:
					stacking: 'normal'
					lineColor: '#666666'
					lineWidth: 1
					marker:
						lineWidth: 1
						lineColor: '#666666'

			series: [
				{
					name: "Completed"
					animation: false
					data: data[0]
				}
				{
					name: "Uncompleted"
					animation: false
					data: data[1]
				}
			]
		return
