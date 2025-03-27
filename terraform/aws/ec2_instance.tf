resource "aws_instance" "vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.resource_group_name}-vm"
  }

  user_data = <<EOF
#!/bin/bash
sudo useradd -m -s /bin/bash sebastian
echo "sebastian:Seb123!@#" | sudo chpasswd
sudo usermod -aG sudo sebastian
EOF

  provisioner "remote-exec" {
    inline = [
      "echo VM ready",
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type     = "ssh"
      user     = "sebastian"
      host     = self.public_ip
      password = "Seb123!@#"
      timeout  = "2m"
    }
  }
}
