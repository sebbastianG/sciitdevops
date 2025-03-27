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
      "echo Hello from Terraform"
    ]
  }

  connection {
    type        = "ssh"
    user        = var.vm_admin_username
    host        = self.public_ip
  }
}
