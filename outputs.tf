output "oregon_public_ip" {
  value = aws_instance.ec2_oregon.public_ip
}

output "london_public_ip" {
  value = aws_instance.ec2_london.public_ip
}
