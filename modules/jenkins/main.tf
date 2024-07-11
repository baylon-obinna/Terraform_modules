provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "demo_key" {
  key_name   = "terraform-demo-obinna"  # Replace with your desired key name
  public_key = file("/c/Users/PASCAL/.ssh/id_ed25519.pub")  # Replace with the path to your public key file
}

resource "aws_security_group" "jenkinsSg" {
  name = "jenkinsSg"
  # vpc_id = aws_vpc.myvpc.id, replace with vpc.id and uncomment if its created in a vpc

  ingress {
    description = "HTTP from Jenkins"
    from_port   = 8080
    to_port     = 8080
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
    Name = "Jenkins-sg"
  }
}

resource "aws_instance" "jenkins_server" {
  instance_type = var.instance_type
  ami           = var.ami
  key_name      = aws_key_pair.demo_key.key_name
  security_groups = [aws_security_group.jenkinsSg.name]

  connection {
    type        = "ssh"
    user        = "ubuntu" # Replace with the appropriate username
    private_key = file("/c/Users/PASCAL/.ssh/id_ed25519") # Path to your private key
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install -y fontconfig openjdk-17-jre",
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key",
      "echo \"deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/\" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y jenkins",
      "sudo systemctl enable jenkins",
      "sudo systemctl start jenkins"
    ]
  }
}
