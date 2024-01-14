variable "token" {
  type        = string
  description = "The token used for traefik service"
}

job "traefik" {
  datacenters = ["dc1"]
  type        = "service"

  group "traefik" {
    count = 1

    network {
      mode = "host"

      port "http" {
        static = 80
      }

      port "https" {
        static = 443
      }

      port "traefik" {
        static = 8080
        to     = 8080
      }

      port "db" {
        static = 5432
        to     = 5432
      }
    }


    service {
      name     = "traefik-http"
      provider = "nomad"
      port     = "traefik"
    }

    task "server" {
      driver = "docker"
      config {
        # network_mode = "bridge"
        image = "traefik:v3.0"
        ports = [
          "http",
          "https",
          "traefik",
          "db"
        ]
        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
	  "./logs/:/logs/"
        ]
      }

      # https://doc.traefik.io/traefik/getting-started/configuration-overview/#configuration-file
      template {
        data = <<EOH
[entryPoints]
  [entryPoints.http]
    address = ":80"
  [entryPoints.https]
    address = ":443"
  [entryPoints.traefik]
    address = ":8080"
  [entryPoints.db]
    address = ":5432"

[api]
  dashboard = true
  insecure = true
  debug = true

[providers.nomad]
  refreshInterval = "5s"
  [providers.nomad.endpoint]
    address = "http://{{ env "attr.unique.network.ip-address" }}:4646"
    token   = "${var.token}"

[log]
  level = "DEBUG"
  filePath = "/logs/traefik.log"
EOH

        destination = "local/traefik.toml"
      }
    }
  }
}
