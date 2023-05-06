const express = require('express')
const control = require('../controller/patient_controller')
const router = express.Router()
const pres = require('../models/pres_model')
const patient = require('../models/patient_model')
//const register = require('../services/register')


router.get('/', (req, res) => {
    res.send('Hello World')
})
router.get('/register', (res)=>{
    res.end('Register here!')
})
router.post('/register', control.register)
router.post('/update', control.update)
router.get('/fetchInfo', async (req, res) => {
    try {
        var data = []
        const patientResult = await patient.find({}).sort({DOA: 'desc'})
        for(var i=0; i<patientResult.length; i++){
            const presResult = await pres.find({
                name: `${patientResult[i].name}`,
                contact: `${patientResult[i].contact}`, 
            })
            console.log(presResult)
            data[i] = {
                "name": patientResult[i].name,
                "contact": patientResult[i].contact,
                "age": patientResult[i].age,
                "illness": presResult[0].illness,
                "prescription": presResult[0].prescription,
                "period": presResult[0].period,
                "DOA": presResult[0].DOA,
                "fee": patientResult[i].fee
            }
            console.log(data[i]);
        }
        //const presResult = await pres.find({patientResult[i].name}).sort({DOA: 'desc'})
        
        //const result = [presResult, patientResult]
        res.send(data)
    } catch (error) {
        console.log(error);
    }
})
router.post('/getPatients', async(req, res)=>{
    try {
        const filter = { name: `${req.body.name}` };
        //const presResult = await pres.find(filter).sort({DOA: 'desc'})
        const patientResult = await patient.find(filter).sort({DOA: 'desc'})
       // const result = [presResult, patientResult]
        res.send(patientResult)
    } catch (error) {
        console.log(error);
    }
})
router.post('/addPres', async (req, res)=> {
    try {
        const filter = { name: `${req.body.name}`, contact: `${req.body.contact}` };
        if(!(await patient.find({filter}))){
            res.status(404).json({success: "No such patient exists.\nFirst register the patient."})
        }else{
            const data = await new pres(req.body)
            data.save()
            await patient.findOneAndUpdate(filter, {DOA: `${req.body.DOA}`})
           // const data = await register.pres(req.body)
            res.status(200).json({success: true, data: data})
        }
    } catch (error) {
        console.log(error);
    }
})
router.post('/getPres', async(req, res)=> {
    try {
        const data = []
        const filter = { name: `${req.body.name}`, contact: `${req.body.contact}` };
        const Presdata = await pres.find(filter).sort({date: 'desc'})
        console.log(Presdata);
        if(!Presdata){
            res.status(404).json({success: "No medical history found!"})
        } else{
            const Patientdata = await patient.find(filter)
            for(i = 0; i < Presdata.length; i++){
                data[i] = {
                    "name": Patientdata[0].name,
                    "contact": Patientdata[0].contact,
                    "age": Patientdata[0].age,
                    "illness": Presdata[i].illness,
                    "prescription": Presdata[i].prescription,
                    "period": Presdata[i].period,
                    "DOA": Presdata[i].DOA,
                    "fee": Patientdata[0].fee
                }
            }
            res.status(200).json(data)
        }
    } catch (error) {
        console.log(error);
    }
})
router.post('/searchByDate', async (req, res)=>{
    var data = [];
    //console.log(req.body.date)
    const patientDetails = await patient.find({DOA: `${req.body.date}`})
    // res.json(patientDetails)
    for(var i=0; i<patientDetails.length; i++){
        const presDetails = await pres.find({
            name: `${patientDetails[i].name}`,
            contact: `${patientDetails[i].contact}`, 
            DOA: `${req.body.date}`
        })
        console.log(presDetails)
        data[i] = {
            "name": patientDetails[i].name,
            "contact": patientDetails[i].contact,
            "age": patientDetails[i].age,
            "illness": presDetails[0].illness,
            "prescription": presDetails[0].prescription,
            "period": presDetails[0].period,
            "DOA": presDetails[0].DOA,
            "fee": patientDetails[i].fee
        }
        console.log(data[i]);
    }
    console.log(data);
    res.status(200).json(data)
})

module.exports = router