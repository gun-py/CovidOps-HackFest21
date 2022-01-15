const express = require('express');
const app = express();
const morgan = require('morgan');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const providerRoutes = require('./api/routes/provider');
const requestRoutes = require('./api/routes/request');
const patientRoutes = require('./api/routes/patient');
const communityRoutes = require('./api/routes/community');
const versionRoute = require('./api/routes/version');

mongoose.connect('mongodb+srv://dbUser:' + process.env.MONGO_ATLAS_PW + '@covigenix.rro52.mongodb.net/myFirstDatabase?retryWrites=true&w=majority');

app.use(morgan('dev'));
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header(
        "Access-Control-Allow-Headers",
        "Origin, X-Requested-With, Content-Type, Accept, Authorization"
    );
    if(req.method === 'OPTIONS'){
        res.header("Access-Control-Allow-Methods", "PUT, POST, PATCH, DELETE, GET");
        return res.status(200).json({});
    }
    next();
});

app.use('/provider', providerRoutes);
app.use('/request', requestRoutes);
app.use('/patient', patientRoutes);
app.use('/community', communityRoutes);
app.use('/version', versionRoute);

app.use((req, res, next) => {
    const error = new Error('Not found');
    error.status(404);
    next(error);
});

app.use((error, req, res, next) => {
    res.status(error.status || 500);
    res.json({
        error:{
            message:error.message
        }
    });
});

module.exports = app;