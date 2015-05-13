projects = require '../config/projects'

express = require 'express'
router = express.Router()

router.get '/:id?', (req, res)->

	projectID = '' + req.params.id

	res.render 'index', {projectID, projects}

module.exports = router
