output "drg_id" {
  value       = module.shared_drg.drg_id
  description = "The OCID of the shared DRG to be used by dev and prod environments"
}