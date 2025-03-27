resource "aws_instance" "vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo 'sebastian:Seb123!@#' | chpasswd
              apt-get update -y
              apt-get install -y nginx
              EOF

  tags = {
    Name = "${var.resource_group_name}-vm"
  }
}
