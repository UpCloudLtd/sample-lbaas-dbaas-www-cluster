variable "zone" {
  type = string
}

variable "nas_plan" {
  type = string
}

variable "www_plan" {
  type = string
}

variable "dbaas_plan" {
  type = string
}

variable "redis_plan" {
  type = string
}

variable "lbaas_plan" {
  type = string
}

variable "nas_sdn" {
  type    = string
  default = ""
}

variable "nas_network" {
  type = string
}

variable "lb_sdn" {
  type    = string
  default = ""
}

variable "lb_network" {
  type = string
}

variable "db_network" {
  type = string
}

variable "ssh_key_public" {
  type = string
}

variable "jump_host" {
  type    = string
  default = ""
}

variable "private_key" {
  type    = string
  default = ""
}