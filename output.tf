output "ansible_public_ip" {
 	description = "Public IP address Ansible Server"
  	value = aws_instance.ansible-server.public_ip
}
output "ansible_private_ip" {
 	description = "Private IP address Ansible Server"
  	value = aws_instance.ansible-server.private_ip
}
output "node1_public_ip" {
 	description = "Public IP address node1 Server"
  	value = aws_instance.node1-server.public_ip
}
output "node1_private_ip" {
 	description = "Private IP address node1 Server"
  	value = aws_instance.node1-server.private_ip
}
output "node2_public_ip" {
 	description = "Public IP address node2 Server"
  	value = aws_instance.node2-server.public_ip
}
output "node2_private_ip" {
 	description = "Private IP address node2 Server"
  	value = aws_instance.node2-server.private_ip
}
output "node3_public_ip" {
 	description = "Public IP address node3 Server"
  	value = aws_instance.node3-server.public_ip
}
output "node3_private_ip" {
 	description = "Private IP address node3 Server"
  	value = aws_instance.node3-server.private_ip
}

