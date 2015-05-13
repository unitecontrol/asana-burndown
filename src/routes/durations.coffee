express = require 'express'
router = express.Router()

Engine = require('tingodb')()
db = new Engine.Db('./data/db', {})
collection = db.collection "durationsCron"

router.get '/:projectID', (req, res)->

	collection.findOne {id:req.params.projectID}, (err, result)->
		if err
			res.status(404).send error: 'Hub not found'
		else
			res.send result

module.exports = router
