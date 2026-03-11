resource "null_resource" "ensure_running" {
  triggers = {
    container_id = var.container_id
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOC
      set -euo pipefail
      if [[ -z "${var.pm_api_token_id}" || -z "${var.pm_api_token_secret}" ]]; then
        echo "pm_api_token_id/secret is empty; skipping auto-start" >&2
        exit 0
      fi
      AUTH="Authorization: PVEAPIToken=${var.pm_api_token_id}=${var.pm_api_token_secret}"
      BASE="${var.pm_api_url}/nodes/${var.target_node}/lxc/${var.vmid}"
      curl -sk --noproxy '*' -X POST -H "$AUTH" "$BASE/status/start" >/dev/null || true
      for _ in $(seq 1 30); do
        if curl -sk --noproxy '*' -H "$AUTH" "$BASE/status/current" | grep -q '"status":"running"'; then
          exit 0
        fi
        sleep 5
      done
      echo "Container failed to reach running state within timeout" >&2
      exit 1
    EOC
  }
}
