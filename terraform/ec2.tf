resource aws_key_pair my_key {
  key_name   = "my-key-pair"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA7XNNSjFb9ZnIqtJxqJ91iBwT0/S6uheDkgjUJjn2QC sk_ru@LAPTOP-B7HKO8UT"
}


resource "aws_default_vpc" "kd_default_voc" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "kd_security_group" {
  name        = "automate-sg-kd"
  description = "this will automate sg"
  vpc_id      = aws_default_vpc.kd_default_voc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name = "automate-sg-kd"
  }
}

# locals {
#   instances ={
#     for i in range(var.instance_count): 
#     "worker-${i+1}"=> "t3.micro"

#   }
# }
resource "aws_instance" "control_node" {



  ami           = var.ec2_ami_id 
  instance_type = "t3.micro"
  key_name      = aws_key_pair.my_key.key_name
  #vpc_security_group_ids = [aws_security_group.kd_security_group.id]
  security_groups = [aws_security_group.kd_security_group.name]
  user_data =file("install_ansible.sh")
  root_block_device {
    volume_size = var.aws_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = "control-node"
     Env  = var.environment
  }
}


resource "aws_instance" "ec2_instance" {

  for_each = local.instances

  ami           = var.ec2_ami_id 
  instance_type = each.value
  key_name      = aws_key_pair.my_key.key_name
  #vpc_security_group_ids = [aws_security_group.kd_security_group.id]
  security_groups = [aws_security_group.kd_security_group.name]
  user_data =file("install_nginx.sh")
  root_block_device {
    volume_size = var.aws_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
     Env  = var.environment
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/hosts.ini"

  content = templatefile("${path.module}/templates/inventory.tpl", {
    instances    = local.instance_map
    ssh_key_path = var.ssh_key_path
    control_public_ip = aws_instance.control_node.public_ip
  })
}



