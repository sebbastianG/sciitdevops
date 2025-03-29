
resource "aws_instance" "k3s" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  provisioner "remote-exec" {
    inline = [
      "echo Connected to k3s node"
    ]

    connection {
      type        = "ssh"
      user        = var.vm_admin_username
      private_key = tls_private_key.ec2_key.private_key_pem
      host        = self.public_ip
    }
  }

  tags = {
    Name = "k3s"
  }
}

resource "aws_instance" "monitoring" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  provisioner "remote-exec" {
    inline = [
      "echo Connected to monitoring node"
    ]

    connection {
      type        = "ssh"
      user        = var.vm_admin_username
      private_key = tls_private_key.ec2_key.private_key_pem
      host        = self.public_ip
    }
  }

  tags = {
    Name = "monitoring"
  }
}
