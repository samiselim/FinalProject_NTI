terraform {
  backend "s3" {
    bucket = "fp-statefile-bucket"
    key = "final-statefile"
    region = "eu-west-3"
  }
}

module "vpc" {
  source                 = "./modules/VPC"
  vpc_cidr               = var.vpc_cidr
  public_subnets_config  = var.public_subnets_config
  private_subnets_config = var.private_subnets_config
  vpc_name               = var.vpc_name
} 
module "eks" {
  source = "./modules/EKS"
  subnet_ids = module.vpc.public_subnet_ids
  worker_subnet_ids = module.vpc.public_subnet_ids
}
module "sg" {
  source = "./modules/SG"
  sg_config = var.sg_config
  sg_name = "sg"
  vpc_id = module.vpc.vpc_id
}
module "RDS_SG" {
  source = "./modules/SG"
  sg_config = var.RDS_sg_config
    sg_name = "RDS_sg"
  vpc_id = module.vpc.vpc_id
}

# module "RDS" {
#   source = "./modules/RDS"
#   RDS_cfg = var.RDS_cfg
#   db_subnet_ids = module.vpc.private_subnet_ids
#   db_sg_ids = [module.RDS_SG.sg_id]
# }
# module "SM" {
#   source = "./modules/AWS_SM"
#   RDS_username = var.RDS_cfg["username"][0]
#   RDS_password = var.RDS_cfg["password"][0]
# }

module "backup_plan" {
  source = "./modules/BackupPlan"
  ec2_arn = data.aws_instance.jenkins.arn
}

module "s3" {
  source = "./modules/s3" 
}
module "ECR" {
  source = "./modules/ECR"
  ECR_name = "nti-backend-image"
  mutability = "MUTABLE"  
}
module "ECR2" {
  source = "./modules/ECR"
  ECR_name = "nti-frontend-image"
  mutability = "MUTABLE"  
}
module "jenkins_instance" {
  source = "./modules/EC2"
  ec2_config = var.jenkins_cfg
  ec2_subnet_id = module.vpc.public_subnet_ids[0]
  vpc_id = module.vpc.vpc_id
  sg = module.sg.sg_id
  ami = data.aws_ami.aws_image_latest.id
}

resource "local_file" "public_ips" {
    content = "[jenkins]\n${data.aws_instance.jenkins.public_ip}\n[eks_nodes]\n${data.aws_instances.instances_data.public_ips[0]}\n${data.aws_instances.instances_data.public_ips[1]}"
    filename = "./Ansible_cfg/inventory"
}
