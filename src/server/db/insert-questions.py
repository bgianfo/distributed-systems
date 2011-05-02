
import riak
import urllib2

def getip():
    """ Return the internal IP of this machine """
    try:
        myurl = "http://169.254.169.254/latest/meta-data/local-ipv4"
        hostname = urllib2.urlopen(url=myurl, timeout=1).read()
        return hostname
    except:
        return "127.0.0.1"


client = riak.RiakClient(host=getip(), port=8087,
            transport_class=riak.RiakPbcTransport)

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

entry = questions.new( "cog-1", data = q )
entry.store()


q = {
 "question" : "__________ is the study of the meaning of words and language",
 "a" : "Linguistics",
 "b" : "Encoding",
 "c" : "Semantics",
 "d" : "Syntax",
 "answer" : "c"
}

entry = questions.new( "cog-2", data = q )
entry.store()


q = {
 "question" : "Representations used in thinking include",
 "a" : "Mnemonic devices",
 "b" : "Kinesthesis",
 "c" : "Concepts",
 "d" : "Primarily figments of the imagination",
 "answer" : "c"
}

entry = questions.new( "cog-3", data = q )
entry.store()


q = {
 "question" : "Basic speech sounds are called",
 "a" : "Morphemes",
 "b" : "Syllables",
 "c" : "Phonemes",
 "d" : "Syntax",
 "answer" : "c"
}

entry = questions.new( "cog-4", data = q )
entry.store()


q = {
 "question" : "A solution that correctly states the requirements for success in solving a problem but not in sufficient detail for further action is called a(n) ________ solution",
 "a" : "Heuristic",
 "b" : "General",
 "c" : "Functional",
 "d" : "Specific",
 "answer" : "b"
}

entry = questions.new( "cog-5", data = q )
entry.store()


q = {
 "question" : "Fluency, flexibility, and originality would be most characteristic of which type of thought?",
 "a" : "Convergent thinking",
 "b" : "Mechanical problem-solving",
 "c" : "Rote problem-solving",
 "d" : "Brainstorming",
 "answer" : "d"
}

entry = questions.new( "cog-6", data = q )
entry.store()


q = {
 "question" : "What type of concept is \'uncle\'",
 "a" : "Conjunctive",
 "b" : "Relational",
 "c" : "Relative",
 "d" : "Disjunctive",
 "answer" : "b"
}

entry = questions.new( "cog-7", data = q )
entry.store()


q = {
 "question" : "The inability to see new uses for familiar objects is termed",
 "a" : "Non-flexible thinking",
 "b" : "Functional fixedness",
 "c" : "Proactive inhibition",
 "d" : "Interference",
 "answer" : "b"
}

entry = questions.new( "cog-8", data = q )
entry.store()


q = {
 "question" : "A person who is concerned about health, but who continues to smoke cigarettes, is making an error in judgement called",
 "a" : "Functional fixedness",
 "b" : "Ignoring the base rate",
 "c" : "Representativeness",
 "d" : "Framing",
 "answer" : "b"
}

entry = questions.new( "cog-9", data = q )
entry.store()


q = {
 "question" : "Language is termed productive if it",
 "a" : "Allows for communication of thoughts and ideas",
 "b" : "Is capable of generating new ideas and possibilities",
 "c" : "Increases one\'s adaptation to a changing environment",
 "d" : "Provides a set of rules for making sounds into words and words into sentences",
 "answer" : "b"
}

entry = questions.new( "cog-10", data = q )
entry.store()


q = {
 "question" : "Which of the following is usually associated with creativity?",
 "a" : "Convergent thinking",
 "b" : "Divergent thinking",
 "c" : "Modeling",
 "d" : "Syntax",
 "answer" : "b"
}

entry = questions.new( "cog-11", data = q )
entry.store()


q = {
 "question" : "Heuristics are problem solving strategies which",
 "a" : "Use a trial and error approach",
 "b" : "Use random search strategies",
 "c" : "Guarantee success in solving a problem",
 "d" : "Reduce the number of alternatives",
 "answer" : "d"
}

entry = questions.new( "cog-12", data = q )
entry.store()


q = {
 "question" : "Characteristics of creativity include",
 "a" : "Convergence",
 "b" : "Flexibility",
 "c" : "Gender differences",
 "d" : "Rigid personality factors",
 "answer" : "b"
}

entry = questions.new( "cog-13", data = q )
entry.store()
