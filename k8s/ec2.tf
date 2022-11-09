#key
resource "aws_key_pair" "k8s-key" {
  key_name   = "k8s-key"
  public_key = file("k8s-key.pub")
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amzLinux.id # Amazon Linux 2
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  user_data_replace_on_change = true
  subnet_id                   = aws_subnet.pub10.id

  key_name = aws_key_pair.k8s-key.key_name

  tags = {
    Name = "bastion-web"
  }
}

#ami data 
data "aws_ami" "amzLinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]

  }
}

resource "aws_instance" "mgnt" {
  ami                         = data.aws_ami.amzLinux.id # Amazon Linux 2
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.mgnt.id]
  user_data_replace_on_change = true
  subnet_id                   = aws_subnet.pri11.id

  key_name = aws_key_pair.k8s-key.key_name
  user_data = templatefile("Userdata_mgnt.tftpl", {})

  tags = {
    Name = "mgnt-web"
  }
}