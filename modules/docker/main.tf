# Create a key pair for docker instance to enable ssh login

# Use: Generate a key from host machine before running using ssh-keygen

resource "aws_key_pair" "demo_key" {
  key_name   = "terraform-demo-obinna"  # Replace with your desired key name
  public_key = file("/home/codespace/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}

#Creates a security group for docker server

resource "aws_security_group" "dockerSg" {
  name = "dockerSg"
  # vpc_id = aws_vpc.myvpc.id, # Uncomment and replace with vpc.id if it's created in a VPC

  ingress {
    description = "HTTP from Docker"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH in instance"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Docker-sg"
  }
}

resource "aws_instance" "docker_server" {
  instance_type = var.instance_type
  ami           = var.ami
  key_name      = aws_key_pair.demo_key.key_name
  security_groups = [aws_security_group.dockerSg.name]

  connection {
    type        = "ssh"
    user        = "ubuntu" # Replace with the appropriate username
    private_key = file("/home/codespace/.ssh/id_rsa") # Path to your private key
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      # Add Docker's official GPG key:
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",

      # Add the repository to Apt sources:
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo docker run hello-world"
    ]
  }
}
