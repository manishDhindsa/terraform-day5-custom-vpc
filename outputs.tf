output "public_ip" {
	value = aws_instance.web.public_ip
}

output "instance_id" {
	value = aws_instance.web.id
}

output "vpc_id" {
	value = aws_vpc.lab_vpc.id
}

output "public_subnet_id" {
	value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
	value = aws_subnet.private_subnet.id
}
