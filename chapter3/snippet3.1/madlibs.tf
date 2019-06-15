variable "nouns" {
  default     = ["army", "panther", "walnuts"]
  description = "A list of nouns"
  type        = list(string)
}

variable "adjectives" {
  default     = ["bitter", "sticky", "thundering"]
  description = "A list of adjectives"
  type        = list(string)
}

variable "verbs" {
  default     = ["run", "dance", "love"]
  description = "A list of verbs"
  type        = list(string)
}

variable "adverbs" {
  default     = ["delicately", "beautifully", "quickly"]
  description = "A list of adverbs"
  type        = list(string)
}

variable "numbers" {
  default     = [42, 27, 101]
  description = "A list of numbers"
  type        = list(number)
}
