
locals {
  instances ={
    for i in range(var.instance_count): 
    "worker-${i+1}"=> "t3.micro"

  }
}


locals {
  instance_map = {
    for name, inst in aws_instance.ec2_instance :
    name => {
      private_ip = inst.private_ip
    }
  }
}