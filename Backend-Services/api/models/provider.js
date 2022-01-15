const mongoose = require('mongoose');
const pointSchema = require('./point');

const providerSchema = mongoose.Schema({
    _id: mongoose.Types.ObjectId,
    name: String,
    phone: String,
    area: String,
    location: pointSchema,
    essentials:[String]
});

module.exports = mongoose.model('Provider', providerSchema);