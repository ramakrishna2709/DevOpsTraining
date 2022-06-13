variable "NAME" {
 [CONFIG ...]
}



variable "aws_access_key" {
 description = "The AWS access key."
 default     = "XYXYXACCESSKEYXYXYX"
}

variable "aws_secret_key" {
 description = "The AWS secret key."
 default     = "XYXYSUPERSECRETKEYXYXYX"
}

variable "instance_type" {
 description = "Type of EC2 instance to use"
 default = "t2.small"
}

variable "instance_types" {
 type    = "map"
 default = {
   "dev" = "t2.small"
   "prod" = "t3.large"
 }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}