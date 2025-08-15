  Modules Created:
  -linux-vm
  -nsg
  -vnet

  Vent module details: 
  created virtual network and respective subnet
  output: subnet id

  NSG Module details:
  created network security group and added network security ruules

  Linux VM Module details:
  Added public ip, network interface, ip congiguration, nsg associtaion, os disk and image
  installed nginx to run the server
  Maintained variables and output file seperately


  Root Level configuration:
  Added required providers
  Created Resource group
  called respective modules with variables
  output public ip of virtual machine
  
  Variable, tfvars and gitignore files are maintained seperately