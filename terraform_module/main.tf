provider "aws" {
  region     = "us-west-2"
  access_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

}

module "dev1" {
  source   = "./dev"
  cidr     = "192.168.0.0/24"
  counters = 4
}
