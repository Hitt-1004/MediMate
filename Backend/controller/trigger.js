const { Twilio } = require('twilio');
const presModel = require('../models/pres_model');

const accountSid = 'Sid';
const authToken = 'token';

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
        from: 'number',
      });
    }
  });
}

module.exports = setupTrigger;
