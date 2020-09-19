data "external" "do_bad_stuff" {
  program = ["node", "${path.module}/run.js"]
}
