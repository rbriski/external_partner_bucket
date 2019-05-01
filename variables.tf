variable "profile" {
    description = "The AWS credential profile you want to use"
    default = ""
}

variable "region" {
    description = "The AWS region to use"
    default = "us-west-2"
}

variable "full_user" {
    description = "Name of user with full rights to bucket"
    default = "loom_full"
}

variable "external_user" {
    description = "Name of user with write-only access to bucket"
    default = "loom_external"
}

variable "bucket_name" {
    description = "Name of the bucket"
    default = "loom.test.bucket"
}

