variable "db_sg_ids" {
  type = list(any)
}
variable "db_subnet_ids" {
  type = list(any)
}
variable "RDS_cfg" {
  type = map(any)
}