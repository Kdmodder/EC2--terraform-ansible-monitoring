# output "ec2_public_ip"{
#     value = aws_instance.ec2_instance[*].public_ip
# }
# output "ec2_public_dns"{
#     value = aws_instance.ec2_instance[*].public_dns
# }

# output "ec2_private_ip"{
#     value = aws_instance.ec2_instance[*].private_ip
# }
# output "ec2_private_dns"{
#     value = aws_instance.ec2_instance[*].private_dns
# }

output "instance_details" {
  value = {
    for name, inst in aws_instance.ec2_instance :
    name => {
      public_ip  = inst.public_ip
      private_ip = inst.private_ip
    }
  }
}