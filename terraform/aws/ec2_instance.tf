resource "aws_instance" "vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo 'sebastian:Seb123!@#' | chpasswd
              sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart sshd
              EOF

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "${var.resource_group_name}-vm"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type     = "ssh"
      user     = var.vm_admin_username
      password = "Seb123!@#"
      host     = self.public_ip
      timeout  = "3m"
    }
  }
}
