resource "aws_launch_template" "launch_template" {
  name_prefix   = "launch_template"
  image_id      = var.image_id
  instance_type = "t2.micro"
#   user_data = filebase64("install_appache.sh")
   block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 20
    }
  }
  network_interfaces {
    security_groups = var.security_groups
  }
  tags = {
    "kubernetes.io/cluster/fp_cluster" = "owned"
  }
}

resource "aws_autoscaling_group" "autoScallingGroup" {
  # target_group_arns = var.target_group_arns
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1
  vpc_zone_identifier       = var.subnet_ids

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
    tag {
    key                 = "kubernetes.io/cluster/fp-cluster"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "fp-node-group"
    propagate_at_launch = true
  }
}