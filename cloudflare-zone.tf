
resource "cloudflare_zone" "shirasagi_space_cloudflare_zone" {
  name                = "shirasagi.space"
  paused              = false
  type                = "full"
  vanity_name_servers = []
  account = {
    id   = var.cloudflare_account_id
    name = "Shirasagi0012's Account"
  }
}
