
asana = require './asana'
CronJob = require('cron').CronJob
holidays = require './config/holidays'
projects = require './config/projects'

module.exports = (db)->
	new CronJob '59 59 23 * * 1-5', ->
		pad = (t)->
			(if t < 10 then '0' + t else t)

		now = new Date()
		dayStr = pad(now.getDate()) + '.' + pad(now.getMonth() + 1)

		return if holidays.indexOf(dayStr) != -1

		date = new Date()

		for name, id of projects
			processProject name, id, date

	, null, true


	processProject = (projectName, projectID, date)->
		asana.tasksOfProject projectID, (err, result)->
			return console.error if err

			completedHours = 0
			unCompletedHours = 0
			for {id, name, completed} in result when (match = name.match(/\[(\d+\.?\d*)\]/))?
				duration = +match[1]

				if completed
					completedHours += duration
				else
					unCompletedHours += duration

			durationObj = {date: date, completedHours, unCompletedHours}

			db.collection "durationsCron", (err, collection)->
				return console.error err if err

				collection.update {id: projectID}, {$push:{durations:durationObj}}, (err, res)->
					if err
						console.error "#{new Date()}: error = #{err}"
					else
						if res is 0
							collection.insert {id: projectID, name: projectName, durations:[durationObj]}, (err, res)->
								echoInfo projectName, completedHours, unCompletedHours
						else
							echoInfo projectName, completedHours, unCompletedHours

	echoInfo = (projectName, completed, unCompleted)->
		console.log "#{new Date()}> #{projectName} update result: completed=#{completed}h, unCompleted=#{unCompleted}h"
