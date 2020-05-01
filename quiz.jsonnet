local md = {
  heading(str, level)::
    local prefix = ['' + '#' for i in std.range(1, level)];
    std.join('', prefix) + ' ' + str + '\n',
  link(title, url):: '[%s](%s)' % [title, url],
  paragraph(str):: str,
  manifestDocument(lines):: std.join('\n', lines),
};

local data = {
  name: 'Quiz',
  description: |||
    Welcome to Alisha and Jack's quiz!
    Each round has its own page which can be reached using the links below.
  |||,
  rounds: [
    {
      name: 'Dingbats',
      link: 'questions/dingbats.html',
      questions: [
        {
          question: 'ME  JUST  YOU',
          answer: 'just between me and you',
        },
      ],
    },
    {
      name: 'Palindromes',
      link: 'questions/%s.html',
      questions: [
        {
          question: 'What is the name of the exercise in which one hangs from a bar and lifts oneself up by the arms?',
          answer: 'pullup',
        },
      ],
    },
  ],
};

{
  'index.md': md.manifestDocument(
    [
      md.heading(data.name, 1),
      md.paragraph(data.description),
    ] + std.mapWithIndex(
      function(i, e) md.heading(md.link('%02d - %s' % [i + 1, e.name], 'questions/%s.html' % e.name), 2),
      data.rounds,
    )
  ),
} + {
  ['questions/%s.md' % round.name]: md.manifestDocument(
    [
      md.heading(round.name, 1),
    ] + std.mapWithIndex(
      function(i, e) md.heading('%d. %s' % [i + 1, e.question], 2),
      round.questions,
    ),
  )
  for round in data.rounds
}
