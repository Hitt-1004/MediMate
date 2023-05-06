const register_patient = require('../services/register')
const prescription = require('../models/pres_model')
const patient = require('../models/patient_model')

exports.register = async(req, res) => {
  try {
      console.log(req.body)
      const {name, contact, age, illness, prescription, period, DOA, time, fee} = req.body;
      const succRes = await register_patient.registerPatient(name, contact, age, DOA, time, fee);
      const succResp = await register_patient.pres(name, contact, illness, prescription, period, DOA);
      res.json({status: true, success: "Patient registered successfully."})
  } catch (err) {
      throw err
  }
} 

exports.update = async(req, res) => {
  const filter = { name: `${req.body.name}`, contact: `${req.body.contact}` };
    try {
      console.log(req.body.name)
        const Pres = await prescription.findOneAndUpdate(filter, req.body, {
            new: true,
            runValidators:false
          });
          const Details = await patient.findOneAndUpdate(filter, req.body, {
            new: true,
            runValidators:false
          });
          console.log(Details, Pres);
          if (!Pres) {
            res.status(404).json({})
            console.log('patient does not exist')
          }
          res.status(200).json({
            "name": Details.name,
            "contact": Details.contact,
            "age": Details.age,
            "illness": Pres.illness,
            "prescription": Pres.prescription,
            "period": Pres.period,
            "DOA": Pres.DOA,
            "fee": Details.fee
          },
        );
          // res.status(200).json({
          //   status: 'success',
          //   data: {
          //     Pres,
          //   },
          // });
    } catch (error) {
       //  console.log(error);
    }
}