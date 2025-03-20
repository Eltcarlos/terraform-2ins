variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}

variable "ami_oregon" {
  description = "AMI para Oregon"
  default     = "ami-0526a31610d9ba25a" # ✅ AMI válida para us-west-2
}

variable "ami_london" {
  description = "AMI para Londres"
  default     = "ami-028f5b95688ef01b5" # ✅ AMI válida para eu-west-2
}
