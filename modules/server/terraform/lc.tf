resource "atlas_artifact" "rancher-asg-server" {
  name = "finboxio/rancher-asg-server"
  type = "amazon.image"
  version = "${var.rancher_asg_server_version}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "rancher-userdata-template" {
  template = "${file(concat(path.module, "/templates/cloud-config.yml"))}"

  vars {
    mysql_root_password    = "${var.mysql_root_password}"
    mysql_volume_size      = "${var.mysql_volume_size}"
    rancher_mysql_database = "${var.rancher_mysql_database}"
    rancher_mysql_user     = "${var.rancher_mysql_user}"
    rancher_mysql_password = "${var.rancher_mysql_password}"
    rancher_admin_user     = "${var.rancher_admin_user}"
    rancher_admin_password = "${var.rancher_admin_password}"
    rancher_hostname       = "${var.rancher_hostname}"
    rancher_s3_bucket      = "${aws_s3_bucket.rancher-bucket.bucket}"
    slack_webhook          = "${var.slack_webhook}"
    shudder_sqs_url        = "${aws_sqs_queue.rancher-terminations.id}"
    cluster_size           = "${var.cluster_size}"
    version                = "${atlas_artifact.rancher-asg-server.metadata_full.version}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "rancher-lc" {
  image_id             = "${element(split(",", atlas_artifact.rancher-asg-server.metadata_full.ami_id), index(split(",", atlas_artifact.rancher-asg-server.metadata_full.region), var.region))}"
  name_prefix          = "${var.deployment_id}-rancher-"
  instance_type        = "${var.instance_type}"
  spot_price           = "${var.spot_price}"
  key_name             = "${var.ssh_keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.rancher-ec2-iam-profile.id}"

  security_groups = [
    "${aws_security_group.rancher-sg.id}",
    "${aws_security_group.rancher-internal-sg.id}"
  ]

  ebs_optimized     = "${var.ebs_optimized}"
  enable_monitoring = false
  user_data         = "${template_file.rancher-userdata-template.rendered}"

  root_block_device = {
    volume_size = 16
  }

  lifecycle {
    create_before_destroy = true
  }
}