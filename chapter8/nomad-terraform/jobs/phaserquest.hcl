job "phaserquest" {
  datacenters = ["dc1"]

  group "phaserquest" {
    task "server" {
      driver = "docker"

      config {
        image = "swinkler/phaserquest"
        command = "/bin/bash"
        args = [
            "-c",
            "node server.js -p 8081 --mongoServer 34.212.170.165 --waitForDatabase 5000"
        ]
        force_pull = true
        port_map {

        }

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