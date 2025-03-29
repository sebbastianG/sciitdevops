
resource "aws_instance" "vm" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.vm_sg.id]

  provisioner "remote-exec" {
    inline = [
      "echo Connected!"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.ec2_key.private_key_pem
      host        = self.public_ip
    }
  }

  tags = {
    Name = "TerraformInstance"
  }
}
