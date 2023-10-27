resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet-apps-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-cidr-apps-a
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "subnet-dbs-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-cidr-dbs-a
  availability_zone = "${var.region}a"
}

resource "aws_route_table" "subnet-route-table-apps" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "subnet-route-table-dbs" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "subnet-apps-a-route-table-association" {
  subnet_id      = aws_subnet.subnet-apps-a.id
  route_table_id = aws_route_table.subnet-route-table-apps.id
}

resource "aws_route_table_association" "subnet-dbs-a-route-table-association" {
  subnet_id      = aws_subnet.subnet-dbs-a.id
  route_table_id = aws_route_table.subnet-route-table-dbs.id
}

resource "aws_route" "subnet-route-apps-igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.subnet-route-table-apps.id
}
