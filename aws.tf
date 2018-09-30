provider "aws" {
access_key = "AKIAJUSKAVEOGHGF5SYA"
secret_key = "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"
region = "us-east-1"
}

resource "aws_instance" "webserver" {
ami = "ami-04681a1dbd79675a5"
instance_type = "t2.micro"
key_name = "sumanth1"
ebs_block_device{
      device_name = "/dev/xvda"
      volume_size = 25
      volume_type = "gp2"
    }
tags {
Name = "buildserver"
}
user_data = "${template_file.user_data.rendered}"
}
resource "template_file" "user_data" {
  template = "user.tpl"
  vars {
    cluster = "apache2"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
