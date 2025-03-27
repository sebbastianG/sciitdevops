# terraform/aws/ec2_instance.tf

resource "aws_instance" "vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.resource_group_name}-vm"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type        = "ssh"
      user        = var.vm_admin_username
      host        = self.public_ip
      private_key = file("~/.ssh/sebastian.pem")
      timeout     = "2m"
    }
  }
}
