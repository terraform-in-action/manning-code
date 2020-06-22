templatefile("${path.module}/templates/alice.txt",
    {
        nouns=random_shuffle.random_nouns.result
        adjectives=random_shuffle.random_adjectives.result
        verbs=random_shuffle.random_verbs.result
        adverbs=random_shuffle.random_adverbs.result
        numbers=random_shuffle.random_numbers.result
    })
