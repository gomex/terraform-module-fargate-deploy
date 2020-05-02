# Terraform module to deploy an APP into ECS Fargate cluster.

This module:
* Create tasks.
* Create service.
* Zero downtime deploy.
* Create monitoring using CloudWatch.
* Receive an json with containers definitions.


## Usage

```terraform
module "app-deploy" {
  source                 = "git@github.com:gomex/terraform-module-fargate-deploy.git?ref=v0.1"
  containers_definitions = data.template_file.containers_definitions_json.rendered
  environment            = "development"
  subdomain_name         = "app"
  app_name               = "app"
  hosted_zone_id         = "Z09847195EBZJRXWQDI"
  app_port               = "80"
  cloudwatch_group_name  = "development-app"
}

################   DATA   ################ 

data "template_file" "containers_definitions_json" {
  template = file("./containers_definitions.json")

  vars = {
    APP_VERSION = var.APP_VERSION
    APP_IMAGE   = var.APP_IMAGE
    ENVIRONMENT = "development"
    AWS_REGION  = var.aws_region
  }
}

################   VARIABLES   ################ 
variable "APP_VERSION" {
}

variable "APP_IMAGE" {
  default = "app"
}

variable "aws_region" {
  default = "us-east-1"
}
```

## Container Definition Sample

Create a folder called `templates` and a file called `containers_definitions.json` with the content bellow:

```json
[
  {
    "cpu": 1024,
    "image": "670631891947.dkr.ecr.us-east-1.amazonaws.com/my_app:${APP_VERSION}",
    "memory": 1024,
    "name": "myawesomeapp",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "environment": [
      {
        "name": "AWESOME_ENV_VAR",
        "value": "${AWESOME_ENV_VAR}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "awesomeapp-gp",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "myawesomeapp-${APP_VERSION}"
      }
    }
  }
]
```

* The `name` of one container created on `containers_definitions.json` should be the same as `app_name` passed to module.
* You can configure almost everything as variable, and you probably should do this. 

## Multiple Container Definition Sample

```json
[
  {
    "cpu": 1024,
    "image": "670631891947.dkr.ecr.us-east-1.amazonaws.com/my_app:${APP_VERSION}",
    "memory": 1024,
    "name": "myawesomeapp",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  },
  {
    "cpu": 1024,
    "image": "670631891947.dkr.ecr.us-east-1.amazonaws.com/my_worker:${APP_VERSION}",
    "memory": 1024,
    "name": "myawesomeworker",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_count | Number of tasks that will be deployed for this app. | string | `"1"` | no |
| app\_name | How your app will be called. | string | n/a | yes |
| app\_port | The PORT that will be used to communication between load balancer and container. | string | `"3000"` | no |
| aws\_region | The AWS region to create things in. | string | `"us-east-1"` | no |
| cloudwatch\_group\_name | CloudWatch group name where to send the logs. | string | `"sample-group-name"` | no |
| containers\_definitions | A JSON with all container definitions that should be run on the task. For more http://bit.do/eKzfH | string | n/a | yes |
| environment | The enviroment name where that app will be deployed. | string | `"development"` | no |
| fargate\_cpu | The maximum of CPU that the task can use. | string | `"1024"` | no |
| fargate\_memory | The maximum of memory that the task can use. | string | `"1024"` | no |
| fargate\_version | The fargate version used to deploy inside ECS cluster. | string | `"1.3.0"` | no |
| subdomain\_name | The subdomain that will be create for the app. | string | n/a | yes |

# Wiki

Want to know more? 