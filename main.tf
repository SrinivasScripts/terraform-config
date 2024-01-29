# main.tf

# Network Module
module "network" {
  source   = "./modules/network/"
  az_count = var.az_count
  # Add any other required variables
}

# Security Module
module "security" {
  source   = "./modules/security/"
  vpc_id   = module.network.vpc_id
  app_port = var.app_port
}

# Roles Module
module "roles" {
  source                       = "./modules/roles/"
  ecs_task_execution_role_name = var.ecs_task_execution_role_name
  # Add any other required variables
}

# ECR Repository Module
# module "ecr" {
#   source = "./modules/ecr/"
#   # Add any other required variables
# }

# ECS Module
module "ecs" {
  source    = "./modules/ecs/"
  app_port  = var.app_port
  app_count = var.app_count

  fargate_cpu    = var.fargate_cpu
  fargate_memory = var.fargate_memory
  app_image      = var.app_image

  # Dependencies on other modules
  vpc_id                         = module.network.vpc_id
  security_group_id              = module.security.security_group_id
  ecs_private_subnet_id          = module.network.ecs_private_subnet_id
  ecs_private_subnet_id1         = module.network.ecs_private_subnet_id1
  alb_tg                         = module.alb.alb_tg
  alb_listner                    = module.alb.alb_listner
  aws_iam_role_policy_attachment = module.roles.aws_iam_role_policy_attachment
  ecs_task_execution_role_name   = module.roles.ecs_task_execution_role_name



}

# ALB Module
module "alb" {
  source            = "./modules/alb/"
  app_port          = var.app_port
  health_check_path = var.health_check_path
  # Add any other required variables

  # Dependencies on other modules
  subnet_id         = module.network.subnet_id
  subnet_id1        = module.network.subnet_id1
  vpc_id            = module.network.vpc_id
  security_group_id = module.security.security_group_id
}

# ECS Service Module
# module "ecs_service" {
#   source              = "./modules/ecs/"
#   app_count           = var.app_count
#   app_port            = var.app_port
#   # Add any other required variables

#   # Dependencies on other modules
#   cluster_id          = module.ecs.cluster_id
#   task_definition_arn = module.ecs.task_definition_arn
#   subnet_ids          = module.network.private_subnet_ids
#   security_group_id   = module.security.security_group_id
#   target_group_arn    = module.alb.target_group_arn
# }
