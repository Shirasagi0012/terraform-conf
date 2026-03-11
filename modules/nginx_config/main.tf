locals {
  auto_stream_servers = flatten([
    for service in var.services : [
      for config in service.stream_configs : {
        name                  = "auto_${replace(config.ip, ".", "_")}_${config.listen_port}"
        listen_address        = "0.0.0.0"
        listen_port           = config.listen_port
        protocol              = try(config.protocol, "tcp")
        proxy_timeout         = "60s"
        proxy_connect_timeout = "15s"
        backends = [{
          address = config.ip
          port    = config.backend_port
          weight  = null
        }]
      }
    ]
  ])

  stream_servers = [
    for server in concat(var.manual_configs, local.auto_stream_servers) : {
      name                  = server.name
      listen_address        = coalesce(server.listen_address, "0.0.0.0")
      listen_port           = server.listen_port
      protocol              = lower(coalesce(server.protocol, "tcp"))
      proxy_timeout         = coalesce(server.proxy_timeout, "60s")
      proxy_connect_timeout = coalesce(server.proxy_connect_timeout, "15s")
      backends              = server.backends
    }
  ]

  stream_config = templatefile("${path.module}/templates/nginx_stream.conf.tftpl", {
    servers = local.stream_servers
  })
}


