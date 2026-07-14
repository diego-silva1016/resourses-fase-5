module "dynamodb" {
  source = "../../terraform-blueprints/dynamodb"

  table_name    = var.table_name
  hash_key      = var.hash_key
  hash_key_type = var.hash_key_type
  tags          = var.tags
}
