vpc_name     = "vpc1"
vpc_cidr     = "10.0.0.0/16"

public_subnets_config = {
  subnet_count = [2]
  subnet_cidrs = ["10.0.1.0/24" , "10.0.2.0/24"]
  subnet_azs   = ["eu-west-3a" , "eu-west-3b"]
}
private_subnets_config = {
  subnet_count = [0]
  subnet_cidrs = ["10.0.3.0/24" , "10.0.4.0/24"]
  subnet_azs   = ["eu-west-3a" , "eu-west-3b"]
}
sg_config = {
  ingress_count = [{count = 7}]
  ingress_rule = [{
    port = 443
    protocol = "tcp"
    cidr = "0.0.0.0/0"
  } , 
  { port = 80
    protocol = "tcp"
    cidr = "0.0.0.0/0"
  },
  { port = 22
    protocol = "tcp"
    cidr = "0.0.0.0/0"
  },
  { port = 8080
    protocol = "tcp"
    cidr = "0.0.0.0/0"
  },
  { port = 8081
    protocol = "tcp"
    cidr = "0.0.0.0/0"
  } ,
  { port = 9000
    protocol = "tcp"
    cidr = "0.0.0.0/0"
  },
  { port = 8082
    protocol = "tcp"
    cidr = "0.0.0.0/0"
  }]
}
RDS_sg_config = {
  ingress_count = [{count = 1}]
  ingress_rule = [{
    port = 3306
    protocol = "tcp"
    cidr = "0.0.0.0/0"
  }]
}

RDS_cfg = {
  allocated_storage = [20]
  storage_type = ["gp2"]
  engine = ["mysql"]
  engine_version = ["5.7"]
  instance_class = ["db.t3.micro"]
  username = ["username"]
  password = ["password2"]
}
jenkins_cfg = {
  instance_count = [1]
  instance_type = ["t3.medium"]
  key_name = ["key"]
  instance_name = ["Jenkins"]
}
nexus_cfg = {
  instance_count = [1]
  instance_type = ["t3.medium"]
  key_name = ["key"]
  instance_name = ["Nexus"]
}
sonarqube_cfg = {
  instance_count = [1]
  instance_type = ["t3.medium"]
  key_name = ["key"]
  instance_name = ["SonarQube"]
}