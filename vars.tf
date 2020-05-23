variable "AWS_REGION" {
    default = "us-east-1"
}

variable "AWS_SUBNET_1" {
    default = "us-east-1a"
}
variable "AWS_SUBNET_2" {
    default = "us-east-1b"
}
variable "AWS_SUBNET_3" {
    default = "us-east-1c"
}

variable "AMI" {
    default = "ami-085925f297f89fce1"
}

variable "PATH_TO_PUBLIC_KEY" {
    default = "mykey.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
    default = "mykey"
}