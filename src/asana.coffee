asana = require('asana-api')
projects = require './config/projects'
asanaConfig = require './config/asana'

client = asana.createClient {
	apiKey: asanaConfig['apiKey']
}

exports.tasksOfProject = (projectID, cb)->
	client.request '/projects/' + projectID + '/tasks?opt_fields=id,name,completed', cb