express = require 'express'
router = express.Router()

Engine = require('tingodb')()
db = new Engine.Db('./data/db', {})

router.get '/:projectID', (req, res)->

	collection = db.collection "durationsCron"

	collection.findOne {id:req.params.projectID}, (err, result)->
		if err
			res.status(404).send error: 'Hub not found'
		else
			res.send result

module.exports = router
