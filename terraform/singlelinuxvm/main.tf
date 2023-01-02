# This is a terraform generated template generated from blueprint89

##############################################################
# Keys - CAMC (public/private) & optional User Key (public) 
##############################################################
variable "allow_unverified_ssl" {
  description = "Communication with vsphere server with self signed certificate"
  default     = "true"
}

##############################################################
# Define the vsphere provider 
##############################################################
provider "vsphere" {
  allow_unverified_ssl = var.allow_unverified_ssl
}

provider "camc" {
}

##############################################################
# Define pattern variables 
##############################################################

##############################################################
# Vsphere data for provider
##############################################################
data "vsphere_datacenter" "vm_1_datacenter" {
  name = var.vm_1_datacenter
}

data "vsphere_datastore" "vm_1_datastore" {
  name          = var.vm_1_root_disk_datastore
  datacenter_id = data.vsphere_datacenter.vm_1_datacenter.id
}

data "vsphere_resource_pool" "vm_1_resource_pool" {
  name          = var.vm_1_resource_pool
  datacenter_id = data.vsphere_datacenter.vm_1_datacenter.id
}

data "vsphere_network" "vm_1_network" {
  name          = var.vm_1_network_interface_label
  datacenter_id = data.vsphere_datacenter.vm_1_datacenter.id
}

data "vsphere_virtual_machine" "vm_1_template" {
  name          = var.vm_1-image
  datacenter_id = data.vsphere_datacenter.vm_1_datacenter.id
}



# vsphere vm
resource "vsphere_virtual_machine" "vm_1" {
  name             = var.vm_1_name
  folder           = var.vm_1_folder
  num_cpus         = var.vm_1_number_of_vcpu
  memory           = var.vm_1_memory
  resource_pool_id = data.vsphere_resource_pool.vm_1_resource_pool.id
  datastore_id     = data.vsphere_datastore.vm_1_datastore.id
  guest_id         = data.vsphere_virtual_machine.vm_1_template.guest_id
  scsi_type        = data.vsphere_virtual_machine.vm_1_template.scsi_type
  firmware         = var.vm_1-firmware

  clone {
    template_uuid = data.vsphere_virtual_machine.vm_1_template.id

    customize {
      linux_options {
        domain    = var.vm_1_domain
        host_name = var.vm_1_name
      }

      network_interface {
        ipv4_address = var.vm_1_ipv4_address
        ipv4_netmask = var.vm_1_ipv4_prefix_length
      }

      ipv4_gateway    = var.vm_1_ipv4_gateway
      dns_suffix_list = var.vm_1_dns_suffixes
      dns_server_list = var.vm_1_dns_servers
    }
  }

  network_interface {
    network_id   = data.vsphere_network.vm_1_network.id
    adapter_type = var.vm_1_adapter_type
  }

  disk {
    label          = "${var.vm_1_name}0.vmdk"
    size           = var.vm_1_root_disk_size
    keep_on_remove = var.vm_1_root_disk_keep_on_remove
    datastore_id   = data.vsphere_datastore.vm_1_datastore.id
  }
}

output "vm_1_ip-address" {

  value = vsphere_virtual_machine.vm_1.default_ip_address
}


