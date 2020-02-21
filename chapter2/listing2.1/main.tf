terraform {
  required_version = "~> 0.12"
  required_providers {
    local = "~> 1.2"
  }
}

resource "local_file" "literature" {
  content = <<-EOT
      Sun Tzu said: The art of war is of vital importance to the State.

      It is a matter of life and death, a road either to safety or to 
      ruin. Hence it is a subject of inquiry which can on no account be
      neglected.
    EOT

  filename = "art_of_war.txt"
}