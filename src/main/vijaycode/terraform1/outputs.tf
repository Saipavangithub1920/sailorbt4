output "ec2_public_ip" {
  value = aws_instance.sailorec2.public_ip
}