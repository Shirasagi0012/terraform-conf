locals {
  proxmox_config = {
    pm_api_url            = var.pm_api_url
    pm_api_token_id       = var.pm_api_token_id
    pm_api_token_secret   = var.pm_api_token_secret
    pve_host              = var.pve_host
    pve_user              = var.pve_user
    target_node           = "shirasagi-pve"
    container_source_vmid = "debian-template"
    flatcar_source_vmid   = "flatcar-template"
    storage               = "local-srv"
    bridge                = "vmbr0"
    ssh_private_key       = file(var.ssh_priv_key)
  }

  http_proxy = [
    {
      domain    = "pve.shirasagi.space"
      upstreams = ["https://192.168.10.2:8006"]

      streaming = {
        flush_interval = "-1"
      }

      transport = {
        tls_insecure_skip_verify = true
      }
    },
    {
      domain    = "private-qbittorrent.shirasagi.space"
      upstreams = ["http://192.168.20.3:6002"]

      streaming = {
        flush_interval = "-1"
      }
    },
    {
      domain    = "public-qbittorrent.shirasagi.space"
      upstreams = ["https://192.168.20.3:6001"]

      streaming = {
        flush_interval = "-1"
      }

      transport = {
        tls_insecure_skip_verify = true
      }
    },
    {
      domain    = "nas.shirasagi.space"
      upstreams = ["http://192.168.20.3:5000"]
      streaming = { flush_interval = "-1" }
    },
    {
      domain    = "photos.shirasagi.space"
      upstreams = ["http://192.168.20.3:6008"]
      streaming = { flush_interval = "-1" }
    }
  ]

  stream_proxy = [
    {
      name           = "dev-pve-ssh"
      listen_port    = 22100
      listen_address = "0.0.0.0"
      protocol       = "tcp"
      proxy_timeout  = "20m"
      backends = [
        { address = "192.168.20.100", port = 22 }
      ]
    },
    {
      name           = "pve-ssh"
      listen_port    = 22000
      listen_address = "0.0.0.0"
      protocol       = "tcp"
      proxy_timeout  = "20m"
      backends = [
        { address = "192.168.10.2", port = 22 }
      ]
    },
    {
      name           = "rdp-tcp"
      listen_port    = 33899
      listen_address = "0.0.0.0"
      protocol       = "tcp"
      backends = [
        { address = "192.168.10.100", port = 3389 }
      ]
    },
    {
      name           = "rdp-udp"
      listen_port    = 33899
      listen_address = "0.0.0.0"
      protocol       = "udp"
      backends = [
        { address = "192.168.10.100", port = 3389 }
      ]
    }
  ]
}
