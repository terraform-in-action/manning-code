provider "nomad" {
  address = "http://nomad-nomad-597090714.us-west-2.elb.amazonaws.com:4646"
 // region  = "us-west-2"
}

resource "nomad_job" "mongo" {
  jobspec = file("${path.module}/jobs/mongo.hcl")
}

resource "nomad_job" "phaserquest" {
  jobspec = file("${path.module}/jobs/phaserquest.hcl")
}