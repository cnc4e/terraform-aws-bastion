module "bastion" {
  source = "./modules/bastion"

  vpc_cidr      = var.vpc_cidr
  subnet_cidr   = var.subnet_cidr
  resouce_name  = var.resouce_name
  instance_type = var.instance_type
  start_time    = var.start_time
  stop_time     = var.stop_time
  timezone      = var.timezone
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
  generation    = var.generation
}