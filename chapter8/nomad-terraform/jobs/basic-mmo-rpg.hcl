job "basic-mmo" {
  datacenters = ["dc1"]

  group "example" {
    task "server" {
      driver = "docker"

      config {
        image = "swinkler/basic-mmo-rpg"
      }

      resources {
        network {
          mbits = 10
          port "http" {
            static = "8081"
          }
        }
      }
    }
  }
}