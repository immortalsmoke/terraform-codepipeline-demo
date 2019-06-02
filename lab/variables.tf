variable code_bucket {}
variable linux_code_key {}
variable linux_code_source {} 
variable iam_prefix {}
variable vpc_name {}
variable az_list {
	type = "list"
}
variable private_subnets {
  type = "list"
}
variable public_subnets {
  type = "list"
}
variable iam_role_path {}
variable ssh_scg_name {}
variable ssh_ingress_cidr {
  type = "list"
}
variable vpc_cidr {}
variable environment {}
variable instance_name_prefix {}
