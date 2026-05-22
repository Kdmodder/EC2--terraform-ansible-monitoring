variable "ec2_instance_type"{
  description = "Type of AWS EC2 instance"
  default     = "t3.micro"
}

variable "aws_root_storage_size"{
    description = "Size of root storage in GB"
    default     = 12
}

variable "ec2_ami_id"{
    description = "AMI ID for the EC2 instance"
    default     = "ami-091138d0f0d41ff90" # 
}

variable "instance_count" {
  default = 5
}
variable "environment"{
    description = "Environment tag for the EC2 instances"
    default     = "dev"
}

variable "ssh_key_path" {
  description = "Path to private SSH key"
  default     = "/home/sk_ru/terra-project/terra-ec2/kdmodder-ssh-key"
}

