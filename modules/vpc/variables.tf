variable "vpccidr"{
    default="10.0.0.0/16"
}

variable "publicsubnetcidr"{

}

variable "privateekssubnetcidr"{
  
}
variable "privaterdssubnetcidr"{
   
}
variable "tags"{
    type=map(string)
}
variable "prefix"{
    
}