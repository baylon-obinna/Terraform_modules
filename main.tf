variable "region" {
  description = "This is the region for resource creation"
}

variable "instance_type" {
  description = "This is the instance type to be created, example t2.micro"
}

#In use cases of devlopment, staging and production.

#Different sizes of instances might be required for different use cases

#Works with predifined terraform workspaces, terraforms looksup for predefined workspace and associates corresponding instance size  

/*variable "instance_type" {
  description = "value"
  type = map(string)

  default = {
    "dev" = "t2.micro"
    "stage" = "t2.medium"
    "prod" = "t2.xlarge"
  }
}

module "jenkins_server" {
  source = "./modules/jenkins"
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}*/

variable "ami" {
  description = "This is the AMI to be used for the instance"
}


#Calls the jenkins module prodiving details of jenkins instance creation
module "jenkins_server" {
    source = "./modules/jenkins"
    instance_type = var.instance_type
    ami = var.ami
    region = var.region
  
}

# Calls the docker module prodiving details of docker instance creation
module "docker_server" {
    source = "./modules/docker"
    ami = var.ami
    region = var.region
    instance_type = var.instance_type
  
}

