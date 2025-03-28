resource "aws_instance" "vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "${var.resource_group_name}-vm"
  }

  user_data = <<-EOF
              #!/bin/bash
              useradd -m -s /bin/bash ${var.vm_admin_username}
              echo "${var.vm_admin_username}:${var.vm_admin_password}" | chpasswd
              echo "${var.vm_admin_username} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
              sed -i 's/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart ssh
              EOF

  provisioner "remote-exec" {
    inline = [
      "echo 'Provisioned successfully!'"
    ]

    connection {
      type     = "ssh"
      user     = var.vm_admin_username
      password = var.vm_admin_password
      host     = self.public_ip
      timeout  = "2m"
    }
  }
}
