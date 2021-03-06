resource "aws_security_group" "rancher-production-elasticsearch-sg" {
  name = "rancher-finboxio-production-elasticsearch-host-sg"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "elasticsearch1" {
  source = "../../../modules/host-fleet"
  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "elasticsearch1"
  type = "cattle"

  spot_pools = "${var.elasticsearch1_spot_pools}"

  cluster_size = "1"
  spot_allocation = "lowestPrice"
  spot_price = 0.2
  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  host_security_group = "${aws_security_group.rancher-production-elasticsearch-sg.id}"
  server_security_group = "${var.server_security_group}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"
  slack_channel = "${var.slack_channel}"

  version = "${var.version}"
  ami = "${var.ami}"
}

module "elasticsearch2" {
  source = "../../../modules/host-fleet"
  deployment_id = "${var.deployment_id}"
  environment = "${var.name}"
  group = "elasticsearch2"
  type = "cattle"

  spot_pools = "${var.elasticsearch2_spot_pools}"

  cluster_size = "1"
  spot_allocation = "lowestPrice"
  spot_price = 0.2
  ssh_keypair = "${var.ssh_keypair}"
  shudder_sqs_url = "${var.shudder_sqs_url}"
  config_bucket = "${var.config_bucket}"
  host_security_group = "${aws_security_group.rancher-production-elasticsearch-sg.id}"
  server_security_group = "${var.server_security_group}"

  rancher_hostname = "${var.rancher_hostname}"
  slack_webhook = "${var.slack_webhook}"
  slack_channel = "${var.slack_channel}"

  version = "${var.version}"
  ami = "${var.ami}"
}
