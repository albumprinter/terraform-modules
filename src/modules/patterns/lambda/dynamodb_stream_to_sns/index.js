const TOPIC_ARN = process.env.TOPIC_ARN

const aws = require("aws-sdk")
const sns = new aws.SNS()

function createCorrelationId() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
    const r = (Math.random() * 16) | 0,
      v = c == "x" ? r : (r & 0x3) | 0x8

    return v.toString(16)
  })
}

function createSnsMessage(event) {
  return {
    Message: JSON.stringify(event),
    TopicArn: TOPIC_ARN,
    MessageAttributes: {
      "X-CorrelationId": {
        DataType: "String",
        StringValue: createCorrelationId()
      }
    }
  }
}

exports.handler = async function(event) {
  console.log("Batch size is " + event.Records.length)

  const snsMessage = createSnsMessage(event)

  return sns.publish(snsMessage).promise()
}
