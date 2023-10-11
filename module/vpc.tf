resource "aws_vpc"  "demoVPCRemoteTFState" {
    cidr_block = var.vpc_cidr_main
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.project}-main-vpc"
        "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    }
}

resource "aws_subnet" "public-sub" {
    count = var.az_count
    vpc_id = aws_vpc.demoVPCRemoteTFState.id
    cidr_block = cidrsubnet(var.vpc_cidr_main, var.subnet_cidr_bits)
}