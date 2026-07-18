module "dynamodb" {
  source = "git::https://github.com/diego-silva1016/terraform-blueprints-fase-5.git//dynamodb?ref=main"

  table_name    = var.table_name
  hash_key      = var.hash_key
  hash_key_type = var.hash_key_type
  tags          = var.tags
}
