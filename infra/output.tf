
output "iam_instance_profile" {
	value = "${aws_iam_instance_profile.awscodelab.id}"
}

output "subnet_id" {
  value = "${module.dev_vpc.public_subnets[0]}"
}

output "sec_group" {
  value = "${aws_security_group.ssh_in.id}"
}

output "key_name" {
  value = "${aws_key_pair.awscodelab.key_name}"
}

output "ec2_ins_prefix" {
  value = "${var.instance_name_prefix}"
}

output "env" {
  value = "${var.environment}"
}

output "ssh_public_pem" {
  value = "${tls_private_key.awscodelab.public_key_pem}" 
}

output "ssh_private_pem" {
	value = "${tls_private_key.awscodelab.private_key_pem}"
}

