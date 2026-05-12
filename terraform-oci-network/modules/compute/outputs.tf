output "instance_id" {
  value = oci_core_instance.this.id
}

output "private_ip" {
  value = oci_core_instance.this.private_ip
}