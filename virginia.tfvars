region = "us-east-1"

vpc-cidr = "10.10.0.0/16"

public_subnets = {
  "development": ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"],
  "staging":  ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24", "10.10.14.0/24","10.10.15.0/24", "10.10.16.0/24"]
}
private_subnets = {
  "development": ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"],
  "staging": ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24", "10.10.34.0/24","10.10.35.0/24", "10.10.36.0/24"]
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
  "development": 4,
  "staging":6
}

