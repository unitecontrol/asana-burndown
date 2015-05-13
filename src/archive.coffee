asana = require('asana-api')
projects = require './config/projects'
asanaConfig = require './config/asana'
holidays = require './config/holidays'

client = asana.createClient {
	apiKey: asanaConfig['apiKey']
}

Engine = require('tingodb')()
db = new Engine.Db('./data/db', {})
collection = db.collection "durationsCron"

processProject = (projectID, projectName)->
	client.request '/projects/' + projectID + '/tasks?opt_fields=id,name,created_at,completed,completed_at', (err, tasks)->
		return console.error if err

		firstTime = +Infinity

		allTasks = []
		durations = []

		for {id, name, created_at, completed, completed_at} in tasks when (match = name.match(/\[(\d+\.?\d*)\]/))?
			task = {
				name: name
				created_at: new Date(created_at).getTime()
				duration: +match[1]
			}

			if completed
				task.completed_at = new Date(completed_at).getTime()

				time = new Date(completed_at).getTime()
				if time < firstTime
					firstTime = time

			allTasks.push task


		date = new Date(firstTime)
		firstDate = new Date( date.getFullYear(), date.getMonth(), date.getDate(), 23, 59, 59 )

		time = firstDate.getTime()
		now = Date.now()
		while time < now
			date = new Date(time)
			dayOfWeek = date.getDay()

			pad = (t)-> (if t < 10 then '0' + t else t)
			dayStr = pad(date.getDate()) + '.' + pad(date.getMonth() + 1)

			if dayOfWeek >=1 and dayOfWeek <= 5 and holidays.indexOf(dayStr) == -1
				completedHours = 0
				unCompletedHours = 0

				for task in allTasks when task.created_at <= time
					if task.completed_at? and task.completed_at <= time
						completedHours += task.duration
					else
						unCompletedHours += task.duration

				durationObj = {date, completedHours, unCompletedHours}
				durations.push durationObj

			time += 24 * 60 * 60 * 1000

		collection.insert {id: projectID, name: projectName, durations:durations}, (err, res)->
			return console.error err if err

			console.log projectName, 'saved.'


for name, id of projects
	processProject id, name