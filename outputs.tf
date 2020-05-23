output "ELB" {
  value = aws_elb.autoscaleapp-elb.dns_name
}