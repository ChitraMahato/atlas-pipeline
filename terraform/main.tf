provider "aws" {
  region = "us-east-1"
}

output "public_ip" {
  value = "${aws_instance.httpd.public_ip}"
}

resource "atlas_artifact" "httpd" {
  name = "clstokes/atlas-pipeline-httpd"
  type = "amazon.image"
}

resource "aws_instance" "httpd" {
  ami           = "${atlas_artifact.httpd.metadata_full.region-us-east-1}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    "${aws_security_group.httpd.id}",
  ]

  tags {
    Name = "httpd"
  }
}

resource "aws_security_group" "httpd" {
  name        = "httpd"
  description = "httpd"
}

resource "aws_security_group_rule" "default_egress" {
  security_group_id = "${aws_security_group.httpd.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "httpd" {
  security_group_id = "${aws_security_group.httpd.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
