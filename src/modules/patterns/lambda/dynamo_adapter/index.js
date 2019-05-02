const TOPIC_ARN = process.env.TOPIC_ARN;

const aws = require("aws-sdk");
var sns = new aws.SNS();

exports.handler = function(event, _context, callback) {
  console.log(event);

  var params = {
    Message: JSON.stringify(event),
    TopicArn: TOPIC_ARN
  };

  sns.publish(params, function(error, response) {
    if (error) {
      console.error({
        error,
        event: body
      });
      callback(error);
    } else {
      callback(undefined, response);
    }
  });
};
