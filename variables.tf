variable "fargate_version" {
  default     = "1.3.0"
  description = "The fargate version used to deploy inside ECS cluster."
}

variable "fargate_cpu" {
  type = number
  default     = "1024"
  description = "The maximum of CPU that the task can use."
}

variable "fargate_memory" {
  type = number
  default     = "2048"
  description = "The maximum of memory that the task can use."
}

variable "hosted_zone_id" {
  type = string
  description = "Hosted Zone ID"
}

variable "app_name" {
  type = string
  description = "How your app will be called."
}

variable "app_port" {
  type = number
  default     = "3000"
  description = "The PORT that will be used to communication between load balancer and container."
}

variable "app_count" {
  type = number
  default     = "1"
  description = "Number of tasks that will be deployed for this app."
}

variable "environment" {
  type = string
  default     = "development"
  description = "The enviroment name where that app will be deployed."
}

variable "cloudwatch_group_name" {
  type = string
  default     = "sample-group-name"
  description = "CloudWatch group name where to send the logs."
}

variable "containers_definitions" {
  type = string
  description = "A JSON with all container definitions that should be run on the task. For more http://bit.do/eKzfH"
}

variable "subdomain_name" {
  type = string
  description = "The subdomain that will be create for the app."
}

variable "health_check_path" {
  type = string
  default     = "/"
  description = "Default health check path"
}
