resource "null_resource" "sns_subscribe" {
  emailsCount = "${length(var.emails)}"

  triggers = {
    sns_topic_arn = "${var.sns_topic_arn}"
  }

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${var.sns_topic_arn} --protocol email --notification-endpoint ${element(var.emails, emailsCount.index)} --region ${var.region}"
  }
}
