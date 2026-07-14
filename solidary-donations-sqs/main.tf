module "sqs" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//sqs?ref=main"

  queue_name = var.queue_name
  tags       = var.tags
}
