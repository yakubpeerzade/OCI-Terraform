output "instance_id" {
  value       = oci_core_instance.this.id
  description = "The OCID of the compute instance"
}

output "private_ip" {
  value       = oci_core_instance.this.private_ip
  description = "The internal private IP address of the instance"
}

output "public_ip" {
  value       = oci_core_instance.this.public_ip
  description = "The public IP address of the instance (if assigned)"
}