local md = {
  pandocTitle(obj):: self.manifestDocument(
    ['---'] + [
      '%s: %s' % [field, obj[field]]
      for field in std.objectFields(obj)
    ] + ['---\n']
  ),
  heading(str, level, monospace=false)::
    if monospace then '<h%d style="font-family: monospace">%s</h%d' % [level, str, level] else
      (local prefix = ['' + '#' for i in std.range(1, level)];
       std.join('', prefix) + ' ' + str + '\n'),
  link(title, url):: '[%s](%s)' % [title, url],
  ul(list):: std.join('\n', std.map(function(e) '- %s' % e)) + '\n',
  ol(list):: std.join('\n', std.mapWithIndex(function(i, e) '%d. %s' % [i + 1, e], list)) + '\n',
  paragraph(str):: str + '\n',
  manifestDocument(lines):: std.join('\n', lines),
};

local quiz = {
  new(name, description=null): {
    name: name,
    withRounds(rounds):: self + {
      rounds: rounds,
    },
  },
};

local round = {
  new(name):: {
    name: name,
    safe_name:: std.strReplace(' ', '-', std.toLower(self.name)),
    link:: 'rounds/%s.html' % self.safe_name,
    withQuestions(questions):: self + {
      questions: questions,
    },
  },
};

local question(question, answer) = {
  question: question,
  answer: answer,
};

local data = {
  name: 'Quiz',
  description: "Welcome to Alisha and Jack's quiz!",
  rounds: [
    {
      name: 'Dingbats',
      link: 'questions/dingbats.html',
      questions: [
        {
          q: 'ME JUST YOU',
          a: 'just between me and you',
        },
        {
          q: |||

            ```
              GROUND
              LONDON
            ```
          |||,
          a: 'London Undeground',
        },
        {
          q: |||

            ```
              STEP
              STEP
              PETS
            ```
          |||,
          a: 'two steps forward, one step back',
        },
        {
          q: |||

            ```
                 SAILING
              C C C C C C C
            ```
          |||,
          a: 'sailing on the seven seas',
        },
        {
          q: |||

            ```
              T
              O
              W
              N
            ```
          |||,
          a: 'downtown',
        },
        {
          q: |||

            ```
              MIL1LION
            ```
          |||,
          a: 'one in a million',
        },
        {
          q: |||

            ```
                GROUND
              FEET  FEET
              FEET  FEET
              FEET  FEET
            ```
          |||,
          a: 'six feet underground',
        },
        {
          q: |||

            ```
              LITTLE LITTLE
              LATE   LATE
            ```
          |||,
          a: 'too little too late',
        },
        {
          q: |||

            ```
              X I ST
                N
                G
            ```
          |||,
          a: '10 Downing Street',
        },
        {
          q: |||

            ```
              ABCDEFGHIJKLMNOPQRSTVWXYZ
            ```
          |||,
          a: 'missing you',
        },
      ],
    },
    {
      name: 'Palindromes',
      link: 'questions/%s.html',
      description: 'All questions are hints to a palindromic word like "racecar"',
      questions: [
        {
          q: 'The name of the exercise in which one hangs from a bar and lifts oneself up by the arms',
          a: 'pullup',
        },
        {
          q: 'A type of indian bread',
          a: 'naan',
        },
        {
          q: 'The name of the school bus driver in _The Simpsons_',
          a: 'otto',
        },
        {
          q: 'A word to describe something being more of a particular primary colour than something else',
          a: 'redder',
        },
        {
          q: 'Another name for midday',
          a: 'noon',
        },
        {
          q: 'A tool that features a bubble in liquid',
          a: 'level',
        },
        {
          q: 'A type of narrow boat propelled by means of a double-bladed paddle',
          a: 'kayak',
        },
        {
          q: 'The name of the detection system that uses radio waves. Often used in speed guns.',
          a: 'radar',
        },
      ],
    },
    {
      name: 'General Knowledge',
      questions: [
        {
          q: 'In what year was the first Toy Story released?',
          a: 1995,
        },
        {
          q: 'What colors make up the olympic rings?',
          a: 'blue, yellow, black, green, red',
        },
        {
          q: 'What is the closest prime number to 100',
          a: 101,
        },
        {
          q: 'What is the largest planet in our solar system?',
          a: 'Jupiter',
        },
        {
          q: "What was the name of Girls Aloud's first single?",
          a: 'Sound of the Underground',
        },
        {
          q: 'Can you name three actors that have played Batman?',
          a: 'Lewis G. Wilson, Robert Lowery, Adam West, Michael Keaton, Val Kilmer, George Clooney, Christian Bale, Will Arnett, Ben Affleck',
        },
        {
          q: 'What is the first element in the periodic table?',
          a: 'Hydrogen',
        },
        {
          q: "How many points is the letter 'M' worth in Scrabble?",
          a: 'three',
        },
        {
          q: 'In sailing, does _starboard_ refer to the left or the right?',
          a: 'right',
        },
        {
          q: 'Who wrote _Nineteen Eighty-Four_?',
          a: 'George Orwell',
        },
      ],
    },
    {
      name: 'Songs',
      questions: [
        {
          q: "('20s)\nCommon love isn't for us. We created something phenomenal.",
          a: 'Physical, Dua Lipa',
        },
        {
          q: "('10s)\nBaby, I like your style. Grips on your waist.",
          a: 'One Dance, Drake',
        },
        {
          q: "('00s)\nI remember when. I remember, I remember when I lost my mind.",
          a: 'Crazy, Gnarles Barkley',
        },
        {
          q: "('90s)\nLoad up on guns, bring your friends. It's fun to lose and to pretend.",
          a: 'Smells like Teen Spirit, Nirvana',
        },
        {
          q: "('80s)\nIt's like a jungle sometimes. It makes me wonder how I keep from goin under.",
          a: 'The Message, Grandmaster Flash',
        },
        {
          q: "('70s)\nWhen you're weary, feeling small. When tears are in your eyes, I will dry them all.",
          a: 'Bridge over Troubled Water, Simon and Garfunkel',
        },
        {
          q: "('60s)\nI thought love was only true in fairy tales. Meant for someone else but not for me.",
          a: 'Believe, The Monkees',
        },
        {
          q: "('50s)\nYou shake my nerves and you rattle my brain. Too much love drives a man insane.",
          a: 'Great Balls of Fire, Jerry Lee Lewis',
        },
        {
          q: "('40s)\nOh, the weather outside is frightful. But the fire is so delightful.",
          a: 'Let it Snow, Bing Crosby',
        },
        {
          q: "('30s)\nHave you seen the well to do. Up and down Park Avenue.",
          a: "Puttin' on the Ritz, Fred Astaire",
        },
      ],
    },
    {
      name: 'Specialties',
      questions: [
        {
          q: 'The dance fitness class known as Zumba was invented by a man from which country?',
          a: 'Colombia',
        },
        {
          q: 'According to RetroWow, what is the best selling car of the 1970s?',
          a: 'Ford Cortina',
        },
        {
          q: 'What song features the chorus "No matter what I do, all I can think about is you. Even when I\'m with my boo, boy you know I\'m crazy over you?"',
          a: 'Dilemma by Nelly and Kelly Rowland',
        },
        {
          q: 'In the song "_No Woman, No Cry_", Bob Marley reminisces about sitting in the government yard of which town?',
          a: 'Trenchtown',
        },
        {
          q: 'How long is a marathon to three significant figures?',
          a: 26.2,
        },
        {
          q: 'What colour is Sonic the Hedgehog?',
          a: 'blue',
        },
        {
          q: "What was the name of Rodney's trilby wearing best friend?",
          a: 'Mickey Pierce',
        },
        {
          q: 'Name all five oceans of the world.',
          a: 'Indian, Pacific, Atlantic, Arctic, Southern',
        },
        {
          q: 'In which English city is _Peaky Blinders_ set?',
          a: 'Birmingham',
        },
        {
          q: 'Who is the current presenter of _Antiques Roadshow_?',
          a: 'Fiona Bruce',
        },
      ],
    },
  ],
};

{
  'index.md': md.manifestDocument(
    [
      md.pandocTitle({ title: data.name }),
    ] + [
      md.manifestDocument(
        std.mapWithIndex(
          function(i, r) (
            md.heading(r.name, 2) +
            if i == 0 then '' else (
              md.manifestDocument(
                std.mapWithIndex(
                  function(i, e) (
                    md.heading('%02d. %s' % [i + 1, e.q], 3)
                  ),
                  r.questions
                )
              )
            )

          ),
          data.rounds,
        ),
      ),
    ]
  ),
}
