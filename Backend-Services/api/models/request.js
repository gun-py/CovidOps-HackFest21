const mongoose = require('mongoose');
const pointSchema = require('./point');

const requestSchema = mongoose.Schema({
    _id: mongoose.Types.ObjectId,
    patient_id: mongoose.Types.ObjectId,
    patient_name: String,
    patient_phone: String,
    patient_address: String,
    area: String,
    essential: String,
    location: pointSchema,
    date: Date,
    provider_name: String,
    provider_phone: String,
    provider_id: mongoose.Types.ObjectId,
    sought_approval: Boolean,
    approved: Boolean,
});

module.exports = mongoose.model('Request', requestSchema);