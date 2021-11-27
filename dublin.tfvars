region = "eu-west-1"

vpc-cidr = "10.10.10.0/24"

# feel free to change this subnet cidr block if required
public_subnets = {
  "development": ["10.10.10.0/27", "10.10.10.32/27"],
  "staging": ["10.10.10.64/27", "10.10.10.96/27", "10.10.10.64/27"],
}
private_subnets = {
  "development": ["10.10.10.128/27", "10.10.10.160/27"],
  "staging": ["10.10.10.192/27", "10.10.10.224/27", "10.10.10.256/27"]
}

instance_size = {
  "development" : "t2.micro",
  "staging": "t2.micro",
}

asg_min_size = {
  "development": 1,
  "staging": 2
}

asg_max_size = {
  "development": 2,
  "staging": 6
}

subnet_count = {
  "development": 2,
  "staging": 3
}
