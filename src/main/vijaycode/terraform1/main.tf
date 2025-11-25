terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    region = "ap-south-1"
}
######################VPC##########################
resource "aws_vpc" "sailorvpc" {
    cidr_block = "10.0.0.0/16" 
    tags = {
        Name = "sailorvpc"
    } 
}
##################PUBSN###########################
resource "aws_subnet" "sailorpubsn" {
  vpc_id = aws_vpc.sailorvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "sailorpubsn"
  }
}
##################IG##########################
resource "aws_internet_gateway" "sailorig" {
    vpc_id = aws_vpc.sailorvpc.id
    tags = {
      Name = "sailorig"
    }
}
######################RT######################
resource "aws_route_table" "sailorrt" {
    vpc_id = aws_vpc.sailorvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sailorig.id
    }
    tags = {
      Name = "sailor publicrt"
    }
}
resource "aws_route_table_association" "sailorrtass" {
    subnet_id = aws_subnet.sailorpubsn.id
    route_table_id = aws_route_table.sailorrt.id 
}

#################### KEYPAIR ###########################
resource "aws_key_pair" "jenkins_kp" {
    public_key = file("/var/lib/jenkins/.ssh/jenkins_kp.pub")
    key_name = "jenkins_kp"
  
}

################## Security Groups #####################

resource "aws_security_group" "sshsg" {
    vpc_id = aws_vpc.sailorvpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }  
}

resource "aws_security_group" "tomcatsg" {
    vpc_id = aws_vpc.sailorvpc.id
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }  
}

############ EC2_Instance #########################

resource "aws_instance" "sailorec2" {
  #vpc_id = aws_vpc.sailorvpc.id
  subnet_id = aws_subnet.sailorpubsn.id
  key_name = aws_key_pair.jenkins_kp.key_name
  instance_type = "t2.micro"
  ami = "ami-02b8269d5e85954ef"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.sshsg.id , aws_security_group.tomcatsg.id]
  tags = {
    Name = "sailorec2"
  }
}
