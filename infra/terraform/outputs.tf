output "devops-igw-id"{
    description = "ID of the created Internet Gateway"
    value = aws_internet_gateway.gw.id
}
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.devops_vpc.id
}
output "subnet-a-id" {
  description = "ID of the created subnet a"
  value       = aws_subnet.subnet_a.id
}
output "subnet-b-id" {
  description = "ID of the created subnet b"
  value       = aws_subnet.subnet_b.id
}

output "public-rout-table-id" {
  description = "ID of the created public rout table"
  value       = aws_route_table.public_rt.id
}

output "aws-security-group-id" {
  description = "ID of the created security group devops_sg"
  value       = aws_security_group.devops_sg.id
}
output "jenkins-host-public-p" {
  description = "Public IP address of jenkins_host"
  value       = aws_instance.jenkins_host.public_ip
}
output "k8s-node1-public-ip" {
  description = "Public IP address of k8s_node1"
  value       = aws_instance.k8s_node1.public_ip
}

output "k8s-node2-public-ip" {
  description = "Public IP address of k8s_node2"
  value       = aws_instance.k8s_node2.public_ip
}
