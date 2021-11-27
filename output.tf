output "elb_dns_name" {
  value = aws_elb.webapp_elb.dns_name
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_subnets_cidr" {
  value = module.vpc.private_subnets_cidr_blocks
}


