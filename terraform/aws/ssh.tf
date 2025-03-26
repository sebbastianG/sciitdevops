# Generate a new SSH key pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair using the generated public key
resource "aws_key_pair" "generated" {
  key_name   = "sebastian"  # This will be your key_name used in EC2
  public_key = tls_private_key.ssh.public_key_openssh
}
