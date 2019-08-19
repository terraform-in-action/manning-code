job "mongo" {
  datacenters = ["dc1"]

  group "mongo" {
    task "server" {
      driver = "docker"

      config {
        image = "mongo:3.4.4"
        volumes = ["mongo:/data/db"]
      }

      resources {
        network {
          mbits = 10
          port "http" {
            static = "27017"
          }
        }
      }
    }
  }
}