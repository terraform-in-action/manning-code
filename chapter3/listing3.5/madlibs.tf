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


data "template_file" "madlib" {
  template = file("./alice.txt")
  vars = {
    ADJECTIVE0 = random_shuffle.random_adjectives.result[0]
    ADJECTIVE1 = random_shuffle.random_adjectives.result[1]
    ADJECTIVE2 = random_shuffle.random_adjectives.result[2]
    ADJECTIVE3 = random_shuffle.random_adjectives.result[3]
    ADJECTIVE4 = random_shuffle.random_adjectives.result[4]
    NOUN0      = random_shuffle.random_nouns.result[0]
    NOUN1      = random_shuffle.random_nouns.result[1]
    NOUN2      = random_shuffle.random_nouns.result[2]
    NOUN3      = random_shuffle.random_nouns.result[3]
    NOUN4      = random_shuffle.random_nouns.result[4]
    NOUN5      = random_shuffle.random_nouns.result[5]
    NOUN6      = random_shuffle.random_nouns.result[6]
    NOUN7      = random_shuffle.random_nouns.result[7]
    NOUN8      = random_shuffle.random_nouns.result[8]
    NOUN9      = random_shuffle.random_nouns.result[9]
    NUMBER0    = random_shuffle.random_numbers.result[0]
    VERB0      = random_shuffle.random_verbs.result[0]
    VERB1      = random_shuffle.random_verbs.result[1]
  }
}

resource "local_file" "mad_lib" {
  content  = data.template_file.madlib.rendered
  filename = "madlibs.txt"
}
