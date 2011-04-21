
import riak


client = riak.RiakClient()

# 
# Questions are from: 
# http://www.diva-girl-parties-and-stuff.com/art-trivia.html
# and
# http://www.appsychology.com/HowPass/MC%20quizes/MCquizeshome.htm
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
entry = questions.new( "art-1", data = q )
entry.store()

q = {
 "question" : "Who painted \'The Scream\' (the famous painting of a man screaming with a nuclear mushroom cloud behind him.)?",
 "a" : "Oskar Kokoschka",
 "b" : "Marc Chagall",
 "c" : "Egon Schiele",
 "d" : "Edvard Munch",
 "answer" : "d"
}
entry = questions.new( "art-2", data = q )
entry.store()


q = {
 "question" : "Which famous twentieth century artist painted \"100 Cans\" (Pop Art)?",
 "a" : "Andy Warhol",
 "b" : "Roy Lichtenstein",
 "c" : "Piet Mondrian",
 "d" : "Jeff Koons",
 "answer" : "a"
}
entry = questions.new( "art-3", data = q )
entry.store()


q = {
 "question" : "What is Pablo Picasso's style of artwork called?",
 "a" : "Realism",
 "b" : "Cubism",
 "c" : "Abstract",
 "d" : "Romanticism",
 "answer" : "b"
}
entry = questions.new( "art-4", data = q )
entry.store()


q = {
  "question" : "What art movement was Yoko Ono associated with during the 1960s?",
	"a" : "Dadaism",
	"b" : "Futurism",
	"c" : "Fluxus",
	"d" : "Post-Impressionism",
	"answer": "c"
}
entry = questions.new( "art-5", data = q )
entry.store()


q = {
 "question" : "Which type of paint dries the most quickly?",
 "a" : " Acrylic",
 "b" : " Watercolor",
 "c" : " Gouache",
 "d" : " Oil",
 "answer" : "a"
}
entry = questions.new( "art-7", data = q )
entry.store()


q = {
 "question" : "In respect to art, what is a body of work?",
 "a" : " A set of life drawings.",
 "b" : " A set of bronze sculptures of figures.",
 "c" : " The collection of paintings of a gallery or museum.",
 "d" : " The collection of paintings an artist has done that are typical of their style, approach, or techniques.",
 "answer" : "d"
}
entry = questions.new( "art-8", data = q )
entry.store()


q = {
 "question" : "Which notorious 20th century European leader said: \'Anyone who sees and paints a sky green and pastures blue ought to be sterilized.\'",
 "a" : "Joseph Stalin",
 "b" : "Benito Mussolini",
 "c" : "Adolf Hitler",
 "d" : "None of the above",
 "answer" : "c"
}
entry = questions.new( "art-9", data = q )
entry.store()


q = {
 "question" : "The first example of cave painting was discovered in 1879.  What country was it found in?",
 "a" : "America",
 "b" : "Spain",
 "c" : "Africa",
 "d" : "China",
 "answer" : "b"
}
entry = questions.new( "art-10", data = q )
entry.store()


q = {
 "question" : "Which 19th-century artist inspired the American Congress to create the National Park System?",
 "a" : "Vincent van Gogh",
 "b" : "Albert Bierstadt",
 "c" : "Ansel Adams",
 "d" : "Winslow Homer",
 "answer" : "b"
}
entry = questions.new( "art-11", data = q )
entry.store()


q = {
 "question" : "Who is famous for painting huge close-ups of flowers?",
 "a" : "Mary Cassatt",
 "b" : "Georgia O\'Keeffe",
 "c" : "Camille Claudel",
 "d" : "Sonia Delauney",
 "answer" : "b"
}

entry = questions.new( "art-11", data = q )
entry.store()

q = {
 "question" : "Whate culture is credited with producing the first ceramics",
 "a" : "The Egyptians",
 "b" : "The Aztecs",
 "c" : "The Chinese",
 "d" : "The Japenese",
 "answer" : "d"
}

entry = questions.new( "art-12", data = q )
entry.store()


q = {
 "question" : "How long did Leonardo da Vinci spend painting the Mona Lisa's lips?",
 "a" : "8 Months",
 "b" : "12 Years",
 "c" : "10 Weeks",
 "d" : "2 Years",
 "answer" : "b"
}

entry = questions.new( "art-13", data = q )
entry.store()

q = {
 "question" : "Whate is it called when therapists use art to help clients deal with emotional issues?",
 "a" : "Crazy Art",
 "b" : "Art Therapy",
 "c" : "Angel Painting",
 "d" : "Self-Portrait",
 "answer" : "b"
}

entry = questions.new( "art-14", data = q )
entry.store()


q = {
 "question" : "When and where was the first pencil invented?",
 "a" : "France in the 1300s AD",
 "b" : "China in 800 AD",
 "c" : "England in the 1500s AD",
 "d" : "Egypt in 500 BC",
 "answer" : "c"
}

entry = questions.new( "art-15", data = q )
entry.store()


q = {
 "question" : "Computer programs capable of doing things that require intelligence when done by people are associated with",
 "a" : "Artificial Intelligence",
 "b" : "Proxemics",
 "c" : "Cerebronic",
 "d" : "Computerized Creativity",
 "answer" : "a"
}

entry = questions.new( "art-15", data = q )
entry.store()
