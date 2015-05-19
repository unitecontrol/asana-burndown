express = require 'express'
router = express.Router()

module.exports = (collection)->
	router.get '/:projectID', (req, res)->
		collection.findOne {id:req.params.projectID}, (err, result)->
			if err
				res.status(404).send error: 'Hub not found'
			else
				res.send result

	return router
