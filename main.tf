variable "region" {
  description = "This is the region for resource creation"
}

variable "instance_type" {
  description = "This is the instance type to be created, example t2.micro"
}

variable "ami" {
  description = "This is the AMI to be used for the instance"
}


module "jenkins_server" {
    source = "./modules/jenkins"
    instance_type = var.instance_type
    ami = var.ami
    region = var.region
  
}

module "docker_server" {
    source = "./modules/docker"
    ami = var.ami
    region = var.region
    instance_type = var.instance_type
  
}