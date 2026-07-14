module "sqs" {
  source = "../../terraform-blueprints/sqs"

  queue_name = var.queue_name
  tags       = var.tags
}
