const mongoose = require('mongoose')
const db = require('../config/db')
const {Schema} = mongoose

const presSchema = new Schema({
    name:{type: String, required: true, unique: false},
    contact:{type: String, required: true},
    illness:{type: String, required: true},
    prescription:{type: String, required: true},
    period:{type: String, required: true},
    DOA:{type: Date, required: true}
})

const presModel = mongoose.model('prescriptions', presSchema)
module.exports = presModel;

//send msg to patients of their prescription and prescribed period