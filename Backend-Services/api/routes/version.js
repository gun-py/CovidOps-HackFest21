const express = require('express');
const router  = express.Router();

router.get('/', (req, res, next) => {
   return res.status(200).json({version: "0.0.1"}); 
});

module.exports = router;