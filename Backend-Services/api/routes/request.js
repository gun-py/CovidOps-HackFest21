const express = require('express');
const router  = express.Router();
const mongoose = require('mongoose');

const Provider = require('../models/provider');
const Request = require('../models/request');

var kmToRadian = function(km){
    var earthRadiusInKm = 6378;
    return km / earthRadiusInKm;
};

//Get providers by essential
router.post('/:essential/nearby', (req, res, next) => {
    const coordinates = req.body.coordinates;
    const essential = req.params.essential;

    Provider.find({
        location:{
            $geoWithin : {
                $centerSphere : [coordinates, kmToRadian(50) ]
            }
        },
        essentials: essential
    },
    "_id name phone area location.coordinates").exec()
    .then(result => {
        var providers = [];
        result.forEach((doc) => {
            var performa = {
                provider_id: doc._id,
                name: doc.name,
                phone: doc.phone,
                area: doc.area,
                coordinates: doc.location.coordinates
            };
            providers.push(performa);
        });
        return res.status(200).json({
            code: 200,
            message: "Fetched providers successfully.",
            providers:providers
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
router.post('/:essential', (req, res, next) => {
    
    const date = new Date();

    const request = new Request({
        _id: mongoose.Types.ObjectId(),

        patient_id: req.body.patientId,
        patient_name: req.body.patientName,
        patient_phone: req.body.patientPhone,
        patient_address: req.body.patientAddress,
        area: req.body.area,
        
        essential: req.params.essential,    
        location: {
            type: "Point",
            coordinates: req.body.coordinates
        },
        date: date,

        provider_name: req.body.providerName,
        provider_phone: req.body.providerPhone,
        provider_id: req.body.providerId,
        sought_approval: false,
        approved: false
    });
    
    request.save()
    .then(result => {
        return res.status(200).json({
            code: 200,
            message: "Added request successfully"
        })
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

router.get('/provider/:provider_id/:essential', (req, res, next) => {
    const providerId = req.params.provider_id;
    const essential = req.params.essential;

    Request.find({
        provider_id: providerId,
        essential: essential
    })
    .then(result => {
        
        var arr = [];
        for(i=0; i<result.length; i++){
            const isAllowed = result[i].approved;

            var performa = {
                location: result[i].location.coordinates,
                request_id: result[i]._id,
                area: result[i].area,
                name: result[i].patient_name,
                phone: result[i].patient_phone,
                address: (isAllowed?result[i].patient_address:"Not available"),
                date: result[i].date
            };
            arr.push(performa);
        }
        
        return res.status(200).json({
            code: 200,
            message: "Fetched requests successfully",
            requests: arr
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

router.get('/approval/:request_id', (req, res, next) => {
    const requestId = req.params.request_id;

    Request.updateOne({
        _id: requestId
    },
    {
        $set:{
            sought_approval: true
        }
    }).exec()
    .then(result => {
        return res.status(200).json({
            code: 200,
            message: "Sought approval successfully",
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

router.post('/share-address/:request_id', (req, res, next) => {
    const requestId = req.params.request_id;
    
    Request.findOne({
        _id: requestId
    }).exec()
    .then(result => {        
        
        Request.updateOne(
        {
            _id: requestId
        },
        {
            $set:{
                approved: true
            }
        }).exec()
        .then(result => {
            return res.status(200).json({
                code: 200,
                message: "Approved address request successfully",
            });
        })
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

router.delete('/:request_id', (req, res, next) => {
    
    const requestId = req.params.request_id;
    Request.deleteOne(
        {
            _id: requestId
        },
    ).exec()
    .then(result => {
        return res.status(200).json({
            code: 200,
            message: "Deleted request successfully"
        })
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

router.get('/patient/:patient_id', (req, res, next) => {
    const patientId = req.params.patient_id;
    Request.find({
        patient_id: patientId
    })
    .then(result => {
        
        var arr = [];
        for(i=0; i<result.length; i++){
            var performa = {
                id: result[i]._id,
                //area: result[i].area,
                essential: result[i].essential,
                date: result[i].date,
                provider_name: result[i].provider_name,
                provider_phone: result[i].provider_phone,
                provider_id: result[i].provider_id,
                sought_approval: result[i].sought_approval,
                approved: result[i].approved
            };
            arr.push(performa);
        }
        
        return res.status(200).json({
            code: 200,
            message: "Fetched requests successfully",
            requests: arr
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

module.exports = router;