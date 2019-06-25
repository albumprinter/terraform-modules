const TOPIC_ARN = process.env.TOPIC_ARN;
const SUBJECT = process.env.SUBJECT;

const crypto = require("crypto");
const aws = require("aws-sdk");
const sns = new aws.SNS();

exports.handler = function(event, _context, callback) {
  try {
    const correlationId = crypto
      .randomBytes(16)
      .toString("hex")
      .replace(/(.{8})(.{4})(.{4})(.{4})(.{12})/, "$1-$2-$3-$4-$5");

    const params = {
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

    sns.publish(params, function(error, response) {
      if (error) {
        console.error({
          error,
          event
        });
        callback(error);
      } else {
        callback(undefined, response);
      }
    });
  } catch (error) {
    throw error
  }
};
