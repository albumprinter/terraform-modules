const SUBJECT = process.env.SUBJECT;
const TOPIC_ARN = process.env.TOPIC_ARN;
const DLQ_URL = process.env.DLQ_URL;

const crypto = require("crypto");
const aws = require("aws-sdk");
const sns = new aws.SNS();
const sqs = new aws.SQS();

function errorHandler(error, event, correlationId, callback) {
  console.error({
    error,
    event,
    correlationId
  });

  var dlqMessage = {
    MessageBody: JSON.stringify(event),
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
      console.error({
        fatal,
        event
      });
      callback(fatal);
    } else {
      callback(undefined, response);
    }
  });
}

function createCorrelationId() {
  return crypto
    .randomBytes(16)
    .toString("hex")
    .replace(/(.{8})(.{4})(.{4})(.{4})(.{12})/, "$1-$2-$3-$4-$5");
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
        console.error("test");
        errorHandler(error, event, correlationId, callback);
      } else {
        callback(undefined, response);
      }
    });
  } catch (error) {
    errorHandler(error, event, correlationId, callback);
  }
};
