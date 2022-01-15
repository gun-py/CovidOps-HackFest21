const express = require('express');
const router  = express.Router();
const mongoose = require('mongoose');
const Patient = require('../models/patient');


module.exports = router;

/* signUp(Registering User) */
router.post('/sign-up', (req, res, next) => {

    const patient = new Patient({
        _id: mongoose.Types.ObjectId(),
        name: req.body.name,
        phone: req.body.phone,
        area: req.body.area,
        address: req.body.address,
        location: {
            type: "Point",
            coordinates: req.body.coordinates
        },
    });

    patient.save()
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


/* CheckSignUp(At time of Login) */
router.get('/:patient_phone/exists', (req, res, next) => {
    const patientPhone = req.params.patient_phone;

    Patient.findOne({phone: patientPhone}).exec()
    .then(result =>{

        if(result){
            return res.status(200).json({
                code: 200,
                message: "Patient exists.",
                id: result._id,
                name: result.name,
                area: result.area,
                address: result.address,
                location: result.location.coordinates
            });
        }else{
            return res.status(200).json({
                code: 201,
                message: "Patient Does not Exists.",
                id: null,
                name: null,
                area: null,
                address: null,
                location: null
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

/* GetProfile */
router.get('/:patientId', (req, res, next) => {
    const patientId = req.params.patientId;

    Patient.findOne({
            _id : patientId
         })
    .exec()
    .then(result => {
            res.status(200).json({
                code: 200,
                message: "Patient Successfully Fetched.",
                name:result.name,
                phone:result.phone,
                area:result.area,
                location: result.location.coordinates,
            });
        }).catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});



/* UpdateProfile */

router.patch('/:patientId', (req, res, next) => {
    const patientId = req.params.patientId;

    Patient.updateOne(
        {
            _id : patientId
        },
        {$set : 
            {
                area: req.body.area,
                address: req.body.address,
                location: {
                    type: "Point",
                    coordinates: req.body.coordinates
                }
            }
        }
    )
    .exec()
    .then(result => {
        res.status(200).json({
            code: 200,
            message: "Profile Successfully Updated." 
        });
    })
    .catch(err => {
        console.log(err);
        return res.status(500).json({
            code: 500,
            error: err
        });
    });
});