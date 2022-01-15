const express = require('express');
const router  = express.Router();
const mongoose = require('mongoose');
const Provider = require('../models/provider');

//Provider check-sign-up
router.get('/:phone/exists', (req, res, next) => {
    const phone = req.params.phone;

    Provider.findOne({phone: phone}).exec()
    .then(result =>{
        
        if(result){
            return res.status(200).json({
                code: 200,
                message: "Provider exists.",
                id: result._id,
                name: result.name,
                area: result.area,
                location: result.location.coordinates,
                essentials: result.essentials
            });
        }else{
            return res.status(200).json({
                code: 201,
                message: "Provider does not exist.",
                id: null,
                name: null,
                area: null,
                location: null,
                essentials: null
            });
        }
        
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

//Provider Sign-Up
router.post('/sign-up', (req, res, next) => {
    const provider = new Provider({
        _id: mongoose.Types.ObjectId(),
        name: req.body.name,
        phone: req.body.phone,
        area: req.body.area,
        location: {
            type: "Point",
            coordinates: req.body.coordinates
        },
        essentials: req.body.essentials
    });

    provider.save()
    .then(result => {
        return res.status(200).json({
            code: 200,
            message: "Signed up successfully",
            id: result._id
        })
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

router.get('/:provider_id', (req, res, next) => {
    const providerId = req.params.provider_id;

    Provider.findOne({
        _id: providerId
    }).exec()
    .then(result => {
        return res.status(200).json({
            code:200,
            message: "Fetched provider profile successfully",
            name: result.name,
            phone: result.phone,
            location: result.location.coordinates,
            area: result.area,
            essentials: result.essentials
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

//Update provider profile
router.patch('/:provider_id', (req, res, next) => {
    const providerId = req.params.provider_id;

    Provider.updateOne(
        {
            _id: providerId
        },
        {
            $set: {
                area: req.body.area,
                location: {
                    type: "Point",
                    coordinates: req.body.coordinates
                }
            }
        }
    ).exec()
    .then(result => {
        return res.status(200).json({
            code:200,
            message: "Updated provider profile successfully",
        });
    }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});

//Update provider essentials list
router.put('/:provider_id', (req, res, next) => {
    const providerId = req.params.provider_id;

    Provider.updateOne(
        {
            _id: providerId
        },
        {
            $set: {
                essentials: req.body.essentials
            }
        }
    ).exec()
    .then(result => {
        return res.status(200).json({
            code:200,
            message: "Updated provider essentials list successfully",
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