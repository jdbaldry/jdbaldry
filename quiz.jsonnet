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
  br():: '\n',
  paragraph(str):: str + '\n',
  manifestDocument(lines):: std.join('\n', lines),
};

local quiz = {
  new(name, description=null): {
    name: name,
    [if description != null then 'description']: description,
    rounds:: [],
    withRounds(rounds):: self + {
      rounds::: rounds,
    },
    renderMarkdown()::
      local q = self;
      md.manifestDocument([
        md.pandocTitle({ title: q.name }),
      ] + [
        round.renderMarkdown() + md.br()
        for round in q.rounds
      ]),
  },
};

local round = {
  new(name, description):: {
    name: name,
    description: description,
    safe_name:: std.strReplace(' ', '-', std.toLower(self.name)),
    link:: 'rounds/%s.html' % self.safe_name,
    questions:: [],
    withQuestions(questions):: self + {
      questions::: questions,
    },
    renderMarkdown()::
      local r = self;
      md.manifestDocument(
        [
          md.heading(r.name, 2),
          md.paragraph(r.description),
        ] +
        std.mapWithIndex(
          function(i, e) e.renderMarkdown(i + 1),
          r.questions
        )
      ),
  },
};

local question = {
  new(q, a):: {
    question: q,
    answer: a,
    renderMarkdown(i)::
      local q = self;
      md.manifestDocument([
        md.heading('%02d.' % i, 3),
        md.paragraph(q.question),
        md.paragraph('<aside class="notes">%s</aside>' % q.answer),
      ]),
  },
};

{
  local q = quiz.new('Quiz', "Welcome to Alisha and Jack's quiz!"),
  local general = round.new('General Knowledge', 'Random trivia!').withQuestions([
    question.new('In what year was the first Toy Story released?', 1995),
    question.new('Which colors make up the olympic rings?', 'red, yellow, green, blue, black'),
    question.new('What is the closest prime number to 100?', 101),
    question.new('Which is the largest planet in our solar system?', 'Jupiter'),
    question.new('Can you name three actors that have played Batman?', 'Lewis G. Wilson, Robert Lowery, Adam West, Michael Keaton, Val Kilmer, George Clooney, Christian Bale, Will Arnett, Ben Affleck'),

    question.new('Which is the first element in the periodic table?', 'Hydrogen (H)'),
    question.new('How many points is the letter _M_ worth in Scrabble?', 'three'),
    question.new('In sailing, does _starboard_ refer to the left or the right?', 'right'),
    question.new('Who wrote the novel _Nineteen Eighty-Four_?', 'George Orwell'),
    question.new('According to _RSBPs Big Garden Bird Watch_, what is the most common garden bird?', 'Sparrow'),

    question.new('What was the first ever Disney feature length film?', 'Snow White and the Seven Dwarves'),
    question.new("Which all girl group from the 1980's had number ones with _Walk like an Egyptian_ and _Eternal Flame_?", 'The Bangles'),
    question.new('Which soft drink was created in 1885 by Charles Alderton of Waco, Texas', 'Dr. Pepper'),
    question.new('How many syllables are there in a Haiku', 17),
    question.new("What is _The Beatles'_ best-selling single in the UK?", 'She Loves You'),

    question.new('The internet abbreviation "TL;DR" stands for what?', "Too Long; Didn't Read"),
    question.new("Which Dutch company is Europe's largest brewer?", 'Heineken International'),
    question.new('_Shark Tank_ is the US version of which BBC2 show?', "Dragon's Den"),
    question.new('What was the nationality of the man that created the dance craze _Zumba_?', 'Colombian'),
    question.new('Which shark species is the second largest fish?', 'Basking shark'),
  ]),
  'index.md': q.withRounds([general]).renderMarkdown(),
}
