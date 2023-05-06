const mongoose = require('mongoose')
const db = require('../config/db')
const {Schema} = mongoose

const patientSchema = new Schema({
    name:{type: String, required: true, unique: false},
    contact:{type: String, required: true},
    age:{type: Number},
    DOA:{type: Date, required: true},
    time:{type: String},
    fee:{type: Number}
})

// patientSchema.actions.compareName = async function(name) {
//     try {
//         return isMatch = await (name == this.name)
//     } catch (error) {
//         throw error
//     }
// }

const patientModel = mongoose.model('patient', patientSchema)
module.exports = patientModel;

//send msg to patients of their prescription