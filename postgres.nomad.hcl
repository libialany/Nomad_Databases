variable "port" {
  description = "port database"
}

variable "NAME_CONTAINER_DATABASE" {
  description = "name database"
}

variable "POSTGRES_USER" {
  description = "user container database"
}

variable "POSTGRES_DB_NAME" {
  description = "name container database"
}

variable "POSTGRES_PASSWORD" {
  description = "password container database"
}

variable  "DOMAIN" {
  description = "domain name"
}
job "postgres-X" {
  datacenters = ["dc1"]

  type = "service"

  group "db" {
    count = 1

    network {
      port "db" {
        static = "${var.port}"
        to = 5432
      }
    }

    service {
      name     = "postgres"
      port     = "db"
      provider = "nomad"

      tags = [
	    "traefik.enable=true",
	    "traefik.tcp.routers.${var.NAME_CONTAINER_DATABASE}.rule=HostSNI(`${var.NAME_CONTAINER_DATABASE}.${var.DOMAIN}`)",
	    "traefik.tcp.routers.${var.NAME_CONTAINER_DATABASE}.tls=true",
      "traefik.tcp.routers.${var.NAME_CONTAINER_DATABASE}.service=${var.NAME_CONTAINER_DATABASE}",
	    "traefik.tcp.routers.${var.NAME_CONTAINER_DATABASE}.entrypoints=db",
	    "traefik.tcp.services.${var.NAME_CONTAINER_DATABASE}.loadbalancer.server.port=${var.port}"
	    ]
    }

    task "server" {
      env {
        POSTGRES_DB       = "${var.POSTGRES_USER}"
        POSTGRES_USER     = "${var.POSTGRES_DB_NAME}"
        POSTGRES_PASSWORD = "${var.POSTGRES_PASSWORD}"
      }

      driver = "docker"

      config {
        image = "timescale/timescaledb:latest-pg13"
        ports = ["db"]
      }
    }
  }
}
