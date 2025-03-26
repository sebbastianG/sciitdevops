resource "aws_instance" "vm" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  key_name                    = "your-key-name" # optional
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
    private_key = file(var.ssh_private_key_path)
    host        = self.public_ip
  }
}
