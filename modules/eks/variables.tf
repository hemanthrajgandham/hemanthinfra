

variable "eks_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster."
  type        = list(string)
}


variable "prefix" {
  description = "Prefix for naming resources."
  type        = string
}
variable "node_instance_type" {
  description = "The instance type for the EKS worker nodes."
  type        = list(string)
 
}

variable "desired_size" {
  description = "The desired number of worker nodes in the EKS node group."
  type        = number
}

variable "max_size" {
  description = "The maximum number of worker nodes in the EKS node group."
  type        = number
}
variable "min_size" {
  description = "The minimum number of worker nodes in the EKS node group."
  type        = number
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}