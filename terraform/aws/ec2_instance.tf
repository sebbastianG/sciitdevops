resource "aws_instance" "vm" {
  ami                         = "ami-0c55b159cbfafe1f0" # Update based on region
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = null # Or provide your key name

  tags = {
    Name = "${var.resource_group_name}-vm"
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello from Terraform"
    ]

    connection {
      type        = "ssh"
      user        = var.vm_admin_username
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
