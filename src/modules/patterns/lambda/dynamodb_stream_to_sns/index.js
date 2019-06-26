const SUBJECT = process.env.SUBJECT;
const TOPIC_ARN = process.env.TOPIC_ARN;
const DLQ_URL = process.env.DLQ_URL;
const MAX_SQS_MESSAGE_SIZE = 262144;

const aws = require("./node_modules/aws-sdk");
const sns = new aws.SNS();
const sqs = new aws.SQS();

function errorHandler(error, message, callback) {
  const json = JSON.stringify(message);
  console.error({
    error,
    message: json
  });

  if (Buffer.byteLength(json) <= MAX_SQS_MESSAGE_SIZE) {
    var dlqMessage = {
      MessageBody: json,
      QueueUrl: DLQ_URL
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

function createSnsMessage(event) {
  return {
    Message: JSON.stringify(event),
    TopicArn: TOPIC_ARN,
    Subject: SUBJECT,
    MessageAttributes: {
      "X-CorrelationId": {
        DataType: "String",
        StringValue: createCorrelationId()
      }
    }
  };
}

exports.handler = function(event, _context, callback) {
  const snsMessage = createSnsMessage(event);

  try {
    sns.publish(snsMessage, function(error, response) {
      if (error) {
        errorHandler(error, snsMessage, callback);
      } else {
        callback(undefined, response);
      }
    });
  } catch (error) {
    errorHandler(error, snsMessage, callback);
  }
};
