
variable "zone" {
  type = string
}

variable "lbaas_plan" {
  type = string
}

variable "web_info" {
  type = list(any)
}

variable "lb_sdn" {
  type = string
}