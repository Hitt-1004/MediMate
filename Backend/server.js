const express = require('express')
const connectDB = require('./config/db')
const bodyParser = require('body-parser')
const routes = require('./routes/index.js')
const setupTrigger = require('./controller/trigger')

connectDB()
setupTrigger()

const app = express()
app.use(bodyParser.json())
app.use(routes)
const port = 3000

app.listen(port, console.log(`Server running on port ${port}`))