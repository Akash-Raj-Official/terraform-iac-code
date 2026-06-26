resource "aws_instance" "web" {
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.web-sg.id]
    tags = {
        Name = "Terraform-server"
    }
}