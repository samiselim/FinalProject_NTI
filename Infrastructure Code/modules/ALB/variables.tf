variable "lb_config" {
  type = map(any)
}

variable "lb_subnets" {
  type = list(list(any))
}
variable "sg" {
}
variable "target_group_instances_id_pub" {
    type = list(any)
}
variable "target_group_instances_id_pri" {
    type = list(any)
}
variable "vpc_id" {
}
# variable "nodeGroup_ids" {
  
# }
# variable "nodeGroup_count" {
  
# }