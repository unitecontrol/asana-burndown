express = require 'express'
router = express.Router()

module.exports = (db)->
	router.get '/:projectID', (req, res)->
		db.collection "durationsCron", (err, collection)->
			return console.error err if err

			collection.findOne {id:req.params.projectID}, (err, result)->
				if err
					res.status(404).send error: 'Hub not found'
				else
					res.send result

	return router
