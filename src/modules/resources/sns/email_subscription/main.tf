resource "null_resource" "sns_subscribe" {
  triggers = {
    sns_topic_arn = "${var.sns_topic_arn}"
  }

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${var.sns_topic_arn} --protocol email --notification-endpoint ${element(var.emails, var.emailsCount.index)} --region ${var.region}"
  }
}
