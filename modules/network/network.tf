# network.tf

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main" {
  cidr_block = "172.17.0.0/16"
  enable_dns_hostnames = true
  tags = {
    name = "main"
  }
}

# Create var.az_count public subnets, each in a different AZ
# resource "aws_subnet" "public" {
#   count                   = var.az_count
#   cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
#   availability_zone       = data.aws_availability_zones.available.names[count.index]
#   vpc_id                  = aws_vpc.main.id
#   map_public_ip_on_launch = true
# }
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"
}
resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id 
  tags = {
    Name = "internet_gateway"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route_table" "route_table" {
  //count = var.az_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "subnet_route" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_route" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_table.id
}
# resource "aws_route_table_association" "public" {
#   count          = var.az_count
#   subnet_id      = element(aws_subnet.public.*.id, count.index)
#   route_table_id = element(aws_route_table.public.*.id, count.index)
# }





