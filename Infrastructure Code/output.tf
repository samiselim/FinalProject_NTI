# output "private_ips" {
#   value = data.aws_instances.instances_data.private_ips
# }
# output "jenkins_ip" {
#   value = module.jenkins_instance.public_ec2_ips[0]
# }
output "Jenkins_instance_id" {
  value = data.aws_instance.jenkins.id
}
