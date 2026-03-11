locals {
  auto_proxy = flatten([
    for service in var.services : [
      for config in service.http_configs : {
        domain          = config.domain
        upstreams       = config.upstreams
        tls_instruction = try(config.tls_instruction, null)

        streaming = try(config.streaming, null) == null ? null : {
          flush_interval     = try(config.streaming.flush_interval, null)
          stream_timeout     = try(config.streaming.stream_timeout, null)
          stream_close_delay = try(config.streaming.stream_close_delay, null)
        }

        transport = try(config.transport, null) == null ? null : {
          tls_insecure_skip_verify = try(config.transport.tls_insecure_skip_verify, null)
          dial_timeout             = try(config.transport.dial_timeout, null)
          keepalive                = try(config.transport.keepalive, null)
        }
      }
    ]
  ])

  caddy_proxy = concat(var.manual_configs, local.auto_proxy)

  caddyfile = templatefile("${path.module}/templates/Caddyfile.tftpl", {
    email            = var.caddy_email
    sites            = local.caddy_proxy
    cloudflare_token = var.cloudflare_api_token
  })
}
