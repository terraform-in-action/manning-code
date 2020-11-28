output "vpc" {
  value = module.vpc
}

output "sg" {
  value = {
    lb     = module.lb_sg.security_group.id #B
    db     = module.db_sg.security_group.id #B
    websvr = module.websvr_sg.security_group.id #B
  }
}
