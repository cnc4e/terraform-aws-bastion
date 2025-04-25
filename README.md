# AWS EC2 Instance for Bastion Server Terraform module

Terraform module creates an EC2 instance that can be used as a stepping stone server.

The following functions are available
- Access to instances using Session Manager
- Automatic start and stop of instances
- Userdata(EC2 configuration) for initial installation of Git, Terraform, kubectl, docker

## Requirements
|Name|Version|
|-|-|
|Terraform|>= 1.8.5|
|aws|>= 5.58.0|

## Providers
|Name|Version|
|-|-|
|aws|>= 5.58.0|

## Modules
No modules.

## Resource
|Name|Type|
|-|-|
|[aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)|resource|
|[aws_iam_role.session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)|resource|
|[aws_iam_role_policy_attachment.session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)|resource|
|aws_iam_instance_profile.session_manager|resource|
|[aws_iam_role.ec2_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)|resource|
|[aws_iam_policy.ec2_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)|resource|
|[aws_iam_role_policy_attachment.ec2_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)|resource|
|[aws_scheduler_schedule.bastion_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule)|resource|
|[aws_scheduler_schedule.bastion_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule)|resource|
|[aws_security_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)|resource|
|[aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)|data source|
|[aws_iam_policy.session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy)|data source|
|ec2_schedule_policy.json|setup|
|ec2_schedule.json|setup|
|session_manager_policy.json|setup|
|userdata.sh|setup|

## Inputs
|Name|Description|Type|
|-|-|-|
|resouce_name|Name to give to the resource.|string|
|instance_type|Requested instance type.|string|
|start_time|Time to start up the bastion server(use cron).|string|
|stop_time|Time to stop the bastion server(use cron).|string|
|timezone|The time zone in which the user is located.|string|
|vpc_id|ID of VPC where the bastion server is located.|string|
|subnet_id|ID of subnet where the bastion server is located.|string|

## Outputs
|Name|Description|
|-|-|
|bastion_instance|Information on the instance to be used as a bastion server. See “Attribute Reference” on the [Terraform page](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#:~:text=%24Default.-,Attribute%20Reference,-This%20resource%20exports) for details.|
|bastion_iam_role_session_manager|IAM role to use Session Manager in bastion server.|
|bastion_iam_instance_profile|Instance profile to be assigned to bastion server.|
|bastion_iam_role_schedule|IAM role for scheduling bastion server.|
|bastion_iam_role_policy_schedule|IAM role policy for scheduling bastion server.|
|bastion_schedule_start|Schedule setting of bastion server (start).|
|bastion_schedule_stop|Schedule setting of bastion server (stop).|
|bastion_instance_sg|Security group configured on bastion server.|

## License
Copyright © 2025 Kenta Kato
