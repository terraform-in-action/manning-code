locals {
  templates = tolist(fileset(path.module, "templates/*.txt"))
}