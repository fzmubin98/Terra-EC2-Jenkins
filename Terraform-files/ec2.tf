data "aws_ami" "latest_amazon_linux2" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    #values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    values = [ "al2023-ami-2023.1.20230809.0-kernel-6.1-x86_64" ]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }  
}

resource "aws_instance" "fazle-EC2" {
  ami = data.aws_ami.latest_amazon_linux2.id
  subnet_id = aws_subnet.fazle-subnet.id
  vpc_security_group_ids = [aws_security_group.fazle_SG_EC2.id]
  instance_type = "t2.micro"
  //associate_public_ip_address = "true"
  //key_name = "ec2-key"

  tags = {
    Name = "Fazle-ec2"
    Owner = "Fazle"
  }

 // user_data = file("start.sh")
  
}
