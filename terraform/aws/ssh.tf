resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_key_pair" "generated" {
  key_name   = "generated-${random_id.suffix.hex}"
  public_key = tls_private_key.ssh.public_key_openssh
}
