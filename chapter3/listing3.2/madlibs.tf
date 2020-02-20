terraform {
  required_version = "~> 0.12"
  required_providers {
    random = "~> 2.1"
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

resource "random_shuffle" "random_nouns" {
  input = var.words["nouns"]
}

resource "random_shuffle" "random_adjectives" {
  input = var.words["adjectives"]
}

resource "random_shuffle" "random_verbs" {
  input = var.words["verbs"]
}

resource "random_shuffle" "random_adverbs" {
  input = var.words["adverbs"]
}

resource "random_shuffle" "random_numbers" {
  input = var.words["numbers"]
}