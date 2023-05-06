const patient = require('../models/patient_model')
const prescription = require('../models/pres_model')

class update_or_fetch{
    static async fetchDetails(name){
        try {
            var patientDetails = await patient({name})
            var presDetails = await prescription({name})
            return {patientDetails: patientDetails, presDetails: presDetails}
        } catch (error) {
            throw error
        }
    }

    static async update(name, contact, illness, pres, period, DOA){
        try {
            //var newPres = {$set: {illness: illness, prescription: pres, period: period}}
            prescription.findOneAndUpdate({ name, contact },
                { illness, pres, period, DOA },
                { new: true })
                console.log(name);
        } catch (error) {
            throw error
        }
    }
}

module.exports = update_or_fetch