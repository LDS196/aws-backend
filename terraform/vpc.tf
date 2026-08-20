locals {
  # Три зоны доступности региона eu-central-1
  azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}
 
# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true  # нужно для EKS — ноды регистрируются по hostname
  enable_dns_support   = true
 
  tags = {
    Name = "${var.cluster_name}-vpc"
    # Тег нужен чтобы EKS знал что эта VPC принадлежит кластеру
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
 
# Публичные подсети — по одной на каждую AZ
resource "aws_subnet" "public" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = local.azs[count.index]
 
  # Инстансы в публичной подсети получают публичный IP
  map_public_ip_on_launch = true
 
  tags = {
    Name = "${var.cluster_name}-public-${count.index + 1}"
    # Тег для nginx ingress — знает в каких подсетях создавать NLB
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
 
# Приватные подсети — ноды кластера будут здесь
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 11}.0/24"
  availability_zone = local.azs[count.index]
 
  tags = {
    Name = "${var.cluster_name}-private-${count.index + 1}"
    # Тег для внутренних load balancers
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
 
# Internet Gateway — выход публичных подсетей в интернет
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
 
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}
 
# Elastic IP для NAT Gateway — статический IP через который ноды выходят наружу
resource "aws_eip" "nat" {
  domain = "vpc"
 
  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}
 
# NAT Gateway — один (Single), в первой публичной подсети
# Через него ноды в приватных подсетях выходят в интернет
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
 
  tags = {
    Name = "${var.cluster_name}-nat"
  }
 
  # NAT Gateway требует чтобы IGW уже был создан
  depends_on = [aws_internet_gateway.main]
}
 
# Route Table для публичных подсетей — весь трафик идёт через IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
 
  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}
 
resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
 
# Route Table для приватных подсетей — весь трафик идёт через NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
 
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
 
  tags = {
    Name = "${var.cluster_name}-private-rt"
  }
}
 
resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}