resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "ssh_public_key" {
  value = tls_private_key.ssh.public_key_openssh
}
