output "oregon_public_ip" {
  value = module.ec2_oregon.public_ip
}

output "london_public_ip" {
  value = module.ec2_london.public_ip
}
