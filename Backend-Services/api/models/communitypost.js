const mongoose = require('mongoose');
const pointSchema = require('./point');

const communitypostSchema = mongoose.Schema({
    _id: mongoose.Types.ObjectId,
    person_id: mongoose.Types.ObjectId,
    name: String,
    phone: String,
    area: String,
    details:String,
    location: pointSchema,
    type: Number,
    item: String,
    date: Date
});

module.exports = mongoose.model('CommunityPost', communitypostSchema);