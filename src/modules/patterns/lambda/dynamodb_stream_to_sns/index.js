const SUBJECT = process.env.SUBJECT;
const TOPIC_ARN = process.env.TOPIC_ARN;
const DLQ_URL = process.env.DLQ_URL;
const MAX_SQS_MESSAGE_SIZE = 262144;

const aws = require("./node_modules/aws-sdk");
const sns = new aws.SNS();
const sqs = new aws.SQS();

function errorHandler(error, event, correlationId, callback) {
  const eventJson = JSON.stringify(event);
  console.error({
    error,
    event: eventJson,
    correlationId
  });

  if (Buffer.byteLength(eventJson) <= MAX_SQS_MESSAGE_SIZE) {
    var dlqMessage = {
      MessageBody: eventJson,
      QueueUrl: DLQ_URL,
      MessageAttributes: {
        "X-CorrelationId": {
          DataType: "String",
          StringValue: correlationId || createCorrelationId()
        }
      }
    };

    sqs.sendMessage(dlqMessage, function(fatal, response) {
      if (fatal) {
        console.error({ fatal });
        callback(fatal, response);
      } else {
        callback(undefined, response);
      }
    });
  } else {
    callback();
  }
}

function createCorrelationId() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
    const r = (Math.random() * 16) | 0,
      v = c == "x" ? r : (r & 0x3) | 0x8;

    return v.toString(16);
  });
}

exports.handler = function(event, _context, callback) {
  let correlationId;

  try {
    correlationId = createCorrelationId();
    const snsMessage = {
      Message: JSON.stringify(event),
      TopicArn: TOPIC_ARN,
      Subject: SUBJECT,
      MessageAttributes: {
        "X-CorrelationId": {
          DataType: "String",
          StringValue: correlationId
        }
      }
    };

    sns.publish(snsMessage, function(error, response) {
      if (error) {
        errorHandler(error, event, correlationId, callback);
      } else {
        callback(undefined, response);
      }
    });
  } catch (error) {
    errorHandler(error, event, correlationId, callback);
  }
};
