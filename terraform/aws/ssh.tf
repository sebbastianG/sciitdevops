resource "aws_key_pair" "generated" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}
