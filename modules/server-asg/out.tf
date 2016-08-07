output "s3_bucket" {
  value = "${aws_s3_bucket.rancher-bucket.bucket}"
}

output "shudder_sqs_url" {
  value = "${aws_sqs_queue.rancher-terminations.id}"
}

output "security_group" {
  value = "${aws_security_group.rancher-internal-sg.id}"
}

output "rancher_hostname" {
  value = "${var.rancher_hostname}"
}

output "deployment_id" {
  value = "${var.deployment_id}"
}

output "status_endpoint" {
  value = "${aws_s3_bucket.rancher-status-bucket.website_endpoint}"
}
