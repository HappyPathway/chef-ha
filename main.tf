# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "us-east-1"
}

data "template_file" "chef_cookbook_attributes" {
  template = "${file("${path.module}/templates/cookbook_attributes.rb")}"

  vars = {
    chef_config_path    = "${var.chef_config_path}"
    chef_config_bucket  = "${var.chef_config_bucket}"
    chef_cluster_master = "${var.chef_cluster_master}"
    chef_backend_version = "${var.chef_backend_version}"
    chef_frontend_version = "${var.chef_frontend_version}"
    chef_auth_cidr_addresses = "${var.chef_auth_cidr_addresses}"
  }
}

data "template_file" "setup" {
  template = "${file("${path.module}/templates/setup.sh")}"

  vars = {
    nodename = "${aws_instance.chef-client.private_dns}"
    chef_environment    = "${var.chef_environment}"
    chef_version = "${var.chef_version}"
    os_version = "${var.os_version}"
  }
}

data "template_file" "node" {
  template = "${file("${path.module}/templates/chef_node.json")}"
}

resource "local_file" "chef_cookbook_attributes" {
  content  = "${data.template_file.chef_cookbook_attributes.rendered}"
  filename = "${path.module}/cookbooks/chef-ha/attributes/default.rb"
}



resource "local_file" "setup" {
    content     = "${data.template_file.setup.rendered}"
    filename = "${path.module}/setup.sh"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-${var.os_nickname}-${var.os_version}-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "chef-client" {
  count = "${var.chef_slave_count}"
  depends_on = [
    "local_file.chef_cookbook_attributes"
  ]

  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "m4.large"
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${var.chef_iam_instance_role}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  
  tags = {
    Name = "${var.nodename}"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /tmp/chef",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
    ]
  }
}

resource "local_file" "node" {
  content  = "${data.template_file.node.rendered}"
  filename = "${path.module}/nodes/${aws_instance.chef-client.private_dns}.json"
}

resource "null_resource" "provisioner" {
  # Copies the configs.d folder to /etc/configs.d
  depends_on = [
    "local_file.node"
  ]
  count = "${var.chef_slave_count}"
  
  triggers = {
    instance_ids = "${join(",", aws_instance.chef-client.*.id)}"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = "${element(aws_eip.ip.*.public_ip, count.index)}"
  }

  provisioner "file" {
    source      = "${path.module}/"
    destination = "/tmp/chef"
  }

}

resource "aws_eip" "ip" {
  count = "${var.chef_slave_count}"
  instance = "${element(aws_instance.chef-client.*.id, count.index)}"
  vpc      = true
}

output "ip_address" {
  value = "${aws_eip.ip.*.public_ip}"
}
