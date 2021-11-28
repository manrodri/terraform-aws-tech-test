resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.aws_linux.image_id
  key_name                    = aws_key_pair.web.key_name
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.bastion-sg.id]
  tags = merge(local.common_tags, {"Name": "${terraform.workspace}-bastion"})

}