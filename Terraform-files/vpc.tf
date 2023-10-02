resource "aws_vpc" "fazle-vpc" {
  cidr_block = "192.134.0.0/16"
}

resource "aws_subnet" "fazle-subnet" {
  cidr_block        = "192.134.0.0/24"
  vpc_id            = aws_vpc.fazle-vpc.id
  availability_zone = "us-east-1a"
}
