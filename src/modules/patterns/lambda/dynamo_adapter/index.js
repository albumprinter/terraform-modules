const TOPIC_ARN = process.env.TOPIC_ARN;
const crypto = require("crypto");
const aws = require("aws-sdk");
const sns = new aws.SNS();

exports.handler = function(event, _context, callback) {
  const correlationId = crypto.randomBytes(16).toString("hex");
  const params = {
    Message: JSON.stringify(event),
    TopicArn: TOPIC_ARN,
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
};
