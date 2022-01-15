const express = require('express');
const router  = express.Router();
const mongoose = require('mongoose');
const CommunityPost = require('../models/communitypost')

module.exports = router;


var kmToRadian = function(km){
    var earthRadiusInKm = 6378;
    return km / earthRadiusInKm;
};

//Get community Post Nearby specifically
router.post('/:communityPostType/nearby', (req, res, next) => {
    const coordinates = req.body.coordinates;
    const type = req.params.communityPostType
  
    CommunityPost.find({
        location:{
            $geoWithin : {
                $centerSphere : [coordinates, kmToRadian(200) ]
            }
        },
        type: type
    },
    "_id person_id name phone area item details date location.coordinates").exec()
    .then(result => {
        var posts = [];
        result.forEach(doc => {
            var performa = {
                post_id: doc._id,
                person_id: doc.person_id,
                name: doc.name,
                phone: doc.phone,
                area: doc.area,
                item: doc.item,
                details: doc.details,
                date: doc.date,
                coordinates: doc.location.coordinates
            };
            posts.push(performa);
        });
        return res.status(200).json({
            code: 200,
            message: "Fetched Posts SuccessFully.",
            posts:posts
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});


//Create new request
router.post('/:communityPostType', (req, res, next) => {
    
    const date = new Date();

    const communitypost = new CommunityPost({
        _id: mongoose.Types.ObjectId(),
        person_id: req.body.personId,
        name: req.body.name,
        phone: req.body.phone,
        area: req.body.area,
        details: req.body.details,
        item: req.body.item,
        location: {
            type: "Point",
            coordinates: req.body.coordinates
        },
        type: req.params.communityPostType,
        date: date,
    });
    
    communitypost.save()
    .then(result => {
        return res.status(200).json({
            code: 200,
            message: "Community Post Successfully Added"
        })
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});


/* Delete Community Post */
router.delete('/:post_id', (req, res, next) => {
    
    const postId = req.params.post_id;
    CommunityPost.deleteOne(
        {
            _id: postId
        },   
    ).exec()
    .then(result => {
        return res.status(200).json({
            code: 200,
            message: "Deleted post succesfully."
        })
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});