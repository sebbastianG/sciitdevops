resource "aws_instance" "vm" {
  ami                         = "ami-0c55b159cbfafe1f0" # Update this to match your region
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "${var.resource_group_name}-vm"
  }
}
