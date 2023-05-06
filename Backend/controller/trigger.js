const { Twilio } = require('twilio');
const presModel = require('../models/pres_model');

const accountSid = 'ACa81e931fe7a2add84453337396442fb4';
const authToken = 'b702dfaa23daf370ce5c6123283776a2';

//const client = new MongoClient(accountSid, authToken);
const twilioClient = new Twilio(accountSid, authToken);

const setupTrigger = async () => {

  const changeStream = presModel.watch();

  changeStream.on('change', async (change) => {
    if (change.operationType === 'insert') {
      const doc = change.fullDocument;
      const toNumber = doc.contact;
      console.log("message sent to "+toNumber);
      // Send message using Twilio
      var message = `Your prescription for ${doc.illness} is ${doc.prescription} for a period of ${doc.period}`
      await twilioClient.messages.create({
        body: message,
        to: toNumber,
        from: '+16318685602',
      });
    }
  });
}

module.exports = setupTrigger

// const https = require('https');
// const presModel = require('../models/pres_model')

// const setupTrigger = async() => {
//   const changeStream = presModel.watch();

//   changeStream.on('change', async (change) => {
//     if (change.operationType === 'insert' || change.operationType === 'update') {
//       const doc = change.fullDocument;
//       const toNumber = doc.contact;
//       const message = doc.prescription;

//       // Send message using Nexmo API
//       const apiKey = '694eeab3';
//       const apiSecret = '6hviCw9w9YUWMWcJ';
//       const fromNumber = '7869467357';
//       const apiUrl = `https://rest.nexmo.com/sms/json`;

//       const postData = JSON.stringify({
//         api_key: apiKey,
//         api_secret: apiSecret,
//         from: fromNumber,
//         to: toNumber,
//         text: message,
//       });

//       const options = {
//         hostname: 'rest.nexmo.com',
//         port: 443,
//         path: '/sms/json',
//         method: 'POST',
//         headers: {
//           'Content-Type': 'application/json',
//           'Content-Length': postData.length,
//         },
//       };

//       const req = https.request(options, (res) => {
//         let data = '';

//         res.on('data', (chunk) => {
//           data += chunk;
//         });

//         res.on('end', () => {
//           console.log(JSON.parse(data));
//         });
//       });

//       req.on('error', (error) => {
//         console.error(error);
//       });

//       req.write(postData);
//       req.end();
//     }
//   });
// }

// module.exports = setupTrigger