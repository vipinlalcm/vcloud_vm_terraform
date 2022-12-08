
## Help text for main.tf
**Mandatory fields**
- count
- computer_name
- vm_name
- vm_memory
- vm_cpus
- vm_cpu_cores

**Optional fields: (You may comment it or remove these fields if you don't need it)**
- **metadata** = { ansible_group = "worker" }

  `vm metadata to be used for ansible dynamic inventory`
- **vapp_network_enable** = false

  `create or skip vapp network for VM`
- **override_template_disk** = 51200

  `whether override the default template disk`
- **additional_disk** = 10240
`whether attach additional disk to VM or not`
- **enable_ports** =

        { 
    		ports = ["22"] 
        	dnat_port_auto_increment_suffix = 0 
        	enabled = false 
        }


	`If it is enabled, firewall and DNAT rule will create for that group of VMs, else it 	will not create any firewall and DNAT rules.`


## Help text for main.tf
**Mandatory fields**
- count
- computer_name
- vm_name
- vm_memory
- vm_cpus
- vm_cpu_cores

**Optional fields: (You may comment it or remove these fields if you don't need it)**
- **metadata** = { ansible_group = "worker" }

  `vm metadata to be used for ansible dynamic inventory`
- **vapp_network_enable** = false

  `create or skip vapp network for VM`
- **override_template_disk** = 51200

  `whether override the default template disk`
- **additional_disk** = 10240
`whether attach additional disk to VM or not`
- **enable_ports** =

        { 
    		ports = ["22"] 
        	dnat_port_auto_increment_suffix = 0 
        	enabled = false 
        }


	`If it is enabled, firewall and DNAT rule will create for that group of VMs, else it 	will not create any firewall and DNAT rules.`

Example:-
 
  
    nodes = {
        master : {
            count                  = 0,
            computer_name          = "${var.computer_name}-master",
            vm_name                = "${var.vm_name}-master",
            vm_memory              = 1024,
            vm_cpus                = 2,
            vm_cpu_cores           = 1,
            metadata               = { ansible_group = "control" },
            vapp_network_enable    = false,
            override_template_disk = 51200,
            # additional_disk        = 10240
            enable_ports = {
                ports                           = ["443", "80", "22"]
                dnat_port_auto_increment_suffix = 0
                enabled                         = true
            }
        },
        worker : {
          count               = 0,
          computer_name       = "${var.computer_name}-worker",
          vm_name             = "${var.vm_name}-worker",
          vm_memory           = 1024,
          vm_cpus             = 4,
          vm_cpu_cores        = 2,
          metadata            = { ansible_group = "worker" },
          vapp_network_enable = true,
          # override_template_disk = 51200,
          additional_disk = 10240,
          enable_ports = {
            ports                           = ["443", "80", "22"]
            dnat_port_auto_increment_suffix = 1
            enabled                         = false
          }
      }
      }

  `As you can see, in the above example I have disabled some options for master group but enabled in worker. The optional fields can be used as above.`
