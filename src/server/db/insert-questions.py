
import riak


client = riak.RiakClient()

# 
# Questions are from: 
# http://www.diva-girl-parties-and-stuff.com/art-trivia.html
#

questions = client.bucket('questions')
q = {
 "question" : "In oil painting, why shouldn't you dry your paintings in the dark?",
 "a" : "You can't see when it's dry.",
 "b" : "This may cause a thin film of oil to rise to the surface, yellowing it.",
 "c" : "Paint needs sunlight to dry.",
 "d" : "It will stay wet and eventually go mouldy.",
 "answer" : "b"
 }
entry = questions.new( q["question"], data = q )
entry.store()

"""
q = {
 "question" : "Who painted \'The Scream\' (the famous painting of a man
 screaming with a nuclear mushroom cloud behind him.)?",
 "a" : "Oskar Kokoschka",
 "b" : "Marc Chagall",
 "c" : "Egon Schiele",
 "d" : "Edvard Munch",
 "answer" : " "
}
questions.new( q["question"], q )

q = {
 "question" : "Which famous twentieth century artist painted \"100 Cans\" (Pop Art)?",
 "a" : "Andy Warhol",
 "b" : "Roy Lichtenstein",
 "c" : "Piet Mondrian",
 "d" : "Jeff Koons",
 "answer" : " "
}
questions.new( q["question"], q )

q = {
 "question" : "What is Pablo Picasso's style of artwork called?",
 "a" : "Realism",
 "b" : "Cubism",
 "c" : "Abstract",
 "d" : "Romanticism",
 "answer" : " "
}
questions.new( q["question"], q )

q = {
  "question" : "What art movement was Yoko Ono associated with during the 1960s?",
	"a" : "Dadaism"
	"b" : "Futurism"
	"c" : "Fluxus"
	"d" : "Post-Impressionism"
	"answer": " "
}
questions.new( q["question"], q )

q = {
 "question" : " Which famous twentieth century artist painted "100 Cans" (Pop Art)?"
 "a" : "Andy Warhol"
 "b" : "Roy Lichtenstein"
 "c" : "Piet Mondrian"
 "d" : "Jeff Koons"
 "answer": " "
}
questions.new( q["question"], q )

q = {
 "question" : "What is Pablo Picasso\'s style of artwork called?"
 "a" : "Realism"
 "b" : "Cubism"
 "c" : "Abstract"
 "d" : "45 minutes"
 "answer" : " "
}
questions.new( q["question"], q )

q = {
 "question" : " 14. Which type of paint dries the most quickly?",
 "a" : " Acrylic",
 "b" : " Watercolor",
 "c" : " Gouache",
 "d" : " Oil",
 "answer" : " "
}
questions.new( q["question"], q )

q = {
 "question" : " 15. In respect to art, what is a body of work?",
 "a" : " A set of life drawings.",
 "b" : " A set of bronze sculptures of figures.",
 "c" : " The collection of paintings of a gallery or museum.",
 "d" : " The collection of paintings an artist has done that are typical of their style, approach, or techniques.",
}
questions.new( q["question"], q )

q = {
 "question" : "16. Which notorious 20th century European leader said: \'Anyone
 who sees and paints a sky green and pastures blue ought to be sterilized.\'",
 "a" : "Joseph Stalin",
 "b" : "Benito Mussolini",
 "c" : "Adolf Hitler",
 "d" : "None of the above",
}
questions.new( q["question"], q )

q = {
 "question" : " 17. The first example of cave painting was discovered in 1879.  What country was it found in?",
 "a" : "America"
 "b" : "Spain"
 "c" : "Africa"
 "d" : "China"
}
questions.new( q["question"], q )

q = {
 "question" : " 18. Which 19th-century artist inspired the American Congress to create the National Park System?",
 "a" : "Vincent van Gogh",
 "b" : "Albert Bierstadt",
 "c" : "Ansel Adams",
 "d" : "Winslow Homer",
}
questions.new( q["question"], q )

q = {
 "question" : " 19. Who is famous for painting huge close-ups of flowers?
 "a" : "Mary Cassatt"
 "b" : "Georgia O\'Keeffe"
 "c" : "Camille Claudel"
 "d" : "Sonia Delauney"
}
questions.new( q["question"], q )
"""
