const patientModel = require('../models/patient_model')
const presModel = require('../models/pres_model')

class register {
    static async registerPatient(name, contact, age, DOA, time, fee){
        try {
            const registerPatient = new patientModel(
                {name, contact, age, DOA, time, fee});
            return await registerPatient.save();
        } catch (err) {
            throw err
        }
    }

    static async pres(name, contact, illness, prescription, period, DOA){
        try {
            const pres = new presModel({name, contact, illness, prescription, period, DOA});
            return await pres.save();
        } catch (error) {
            throw error
        }
    }
}

module.exports = register