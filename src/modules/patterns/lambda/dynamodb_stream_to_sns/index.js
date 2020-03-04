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

exports.handler = function(event, _context, callback) {
  console.log("Batch size is " + event.Records.length)

  event.Records.forEach(function(record) {
    const snsMessage = createSnsMessage(record)
    sns.publish(snsMessage, function(error) {
      if (error) {
        console.log("SNS publish failed due to %s; record size is %s", error, record.dynamodb.SizeBytes)
        callback(error, "failed")
        break
      }
    })
  })

  callback(null, "done")
}
