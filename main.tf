terraform {
	required_providers {
		aws = {
		source = "hashicorp/aws"
		version = "~>5.0"
		}	
	}
}

provider "aws" {
	region = var.region
}

resource "aws_vpc" "lab_vpc" {
	cidr_block = "10.0.0.0/16"
	tags = {
		Name = "terraform-lab-vpc"
	}
}

resource "aws_subnet" "public_subnet" {
	vpc_id = aws_vpc.lab_vpc.id
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = true
	tags = {
		Name = "public-subnet"
	}
}

resource "aws_subnet" "private_subnet" {
	vpc_id = aws_vpc.lab_vpc.id
	cidr_block = "10.0.2.0/24"
	tags = {
		Name = "private-subnet"
	}
}

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.lab_vpc.id
	tags = {
		Name = "terraform-igw"
	}
}

resource "aws_route_table" "public_rt" {
	vpc_id = aws_vpc.lab_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}
	tags = {
		Name = "public-route-table"
	}
}

resource "aws_route_table_association" "public_assoc" {
	subnet_id = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
	name = "web_sg"
	description = "Allow SSH and HTTP"
	vpc_id = aws_vpc.lab_vpc.id
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "web" {
	ami = "ami-0c02fb55956c7d316"
	instance_type = "t2.micro"
	key_name = "Terraform_keypair"
	subnet_id = aws_subnet.public_subnet.id

	vpc_security_group_ids = [aws_security_group.web_sg.id]
	tags = {
		Name = "terraform-day5-web"
	}

}



