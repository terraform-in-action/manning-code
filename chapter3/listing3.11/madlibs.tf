terraform {
  required_version = "~> 0.12"
  required_providers {
    random   = "~> 2.1"
    template = "~> 2.1"
  }
}

variable "words" {
  default = {
    nouns      = ["army", "panther", "walnuts", "sandwich", "Zeus", "banana", "cat", "jellyfish", "jigsaw", "violin", "milk", "sun"]
    adjectives = ["bitter", "sticky", "thundering", "abundant", "chubby", "grumpy"]
    verbs      = ["run", "dance", "love", "respect", "kicked", "baked"]
    adverbs    = ["delicately", "beautifully", "quickly", "truthfully", "wearily"]
    numbers    = [42, 27, 101, 73, -5, 0]
  }
  description = "A word pool to use for Mad Libs"
  type        = map(list(string))
}

locals {
  uppercase_words = { for k, v in var.words : k => [for s in v : upper(s)] if k != "numbers" }
}

variable "num_files" {
  default = 100
  type    = number
}

resource "random_shuffle" "random_nouns" {
  count = var.num_files
  input = local.uppercase_words["nouns"]
}

resource "random_shuffle" "random_adjectives" {
  count = var.num_files
  input = local.uppercase_words["adjectives"]
}

resource "random_shuffle" "random_verbs" {
  count = var.num_files
  input = local.uppercase_words["verbs"]
}

resource "random_shuffle" "random_adverbs" {
  count = var.num_files
  input = local.uppercase_words["adverbs"]
}

resource "random_shuffle" "random_numbers" {
  count = var.num_files
  input = var.words["numbers"]
}

resource "local_file" "mad_lib" {
  count = var.num_files
  content = templatefile("madlibs.txt",
    {
      nouns      = random_shuffle.random_nouns[count.index].result
      adjectives = random_shuffle.random_adjectives[count.index].result
      verbs      = random_shuffle.random_verbs[count.index].result
      adverbs    = random_shuffle.random_adverbs[count.index].result
      numbers    = random_shuffle.random_numbers[count.index].result
  })
  filename = "madlibs/madlib-${count.index}.txt"
}
