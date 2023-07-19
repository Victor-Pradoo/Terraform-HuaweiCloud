resource "huaweicloud_vpc" "vpc" {
  name = "vpc-sp"
  cidr = "10.10.0.0/16"
}

resource "huaweicloud_vpc_subnet" "subnet2" {
  name       = "snet-dev"
  cidr       = "10.10.64.0/26"
  gateway_ip = "10.10.64.1"
  vpc_id     = huaweicloud_vpc.vpc.id
  dns_list   = ["100.125.1.22","8.8.8.8"]
}

resource "huaweicloud_networking_secgroup" "mysecgroup" {
  name                 = "defaultsecgroup"
  description          = "My security group"
  delete_default_rules = true
}
resource "huaweicloud_networking_secgroup_rule" "secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.mysecgroup.id
}
/*
resource "huaweicloud_compute_instance" "winbasic" para windows { //can be used to create a windows instance
  name              = "ecs-sei-novo"
  image_id          = "8c26fd28-1a04-4761-8b87-349bde3a1af8"
  flavor_id         = "s6.medium.2"
  security_groups   = ["defaultsecgroup"]
  availability_zone = "sa-brazil-1a"

  network {
    uuid = huaweicloud_vpc_subnet.subnet2.id
  }
}
*/
resource "huaweicloud_compute_instance" "basic" { // creating an ubuntu instance
  name              = "ecs-SaoPaulo"
  image_id          = "3075b5b0-bc15-4998-97b6-7c3d5eb5d911"
  flavor_id         = "s6.large.2"
  security_groups   = ["defaultsecgroup"]
  availability_zone = "sa-brazil-1a"

  network {
    uuid = huaweicloud_vpc_subnet.subnet2.id
  }
}

resource "huaweicloud_networking_secgroup" "secgroup" {
  name        = "terraform_test_security_group"
  description = "terraform security group acceptance test"
}

resource "huaweicloud_rds_instance" "instance" { //creating PostgreSQL instance
  name              = "terraform_test_rds_instance"
  flavor            = "rds.pg.n1.large.2"
  vpc_id            = huaweicloud_vpc.vpc.id
  subnet_id         = huaweicloud_vpc_subnet.subnet2.id
  security_group_id = huaweicloud_networking_secgroup.secgroup.id
  availability_zone = ["sa-brazil-1a"]

  db {
    type     = "PostgreSQL"
    version  = "12"
    password = "Huangwei!120521"
  }

  volume {
    type = "CLOUDSSD"
    size = 100
  }

  backup_strategy {
    start_time = "08:00-09:00"
    keep_days  = 1
  }
}


