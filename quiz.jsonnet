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
  local dingbats = round.new('Dingbats', 'Say what you see!').withQuestions([
    question.new('<p style="font-family: monospace">ME JUST YOU</p>', 'just between you and me'),
    question.new('<div style="font-family: monospace">GROUND<br>LONDON</div>', 'London Underground'),
    question.new('<div style="font-family: monospace">\nSTEP\n<br>\nSTEP\n<br>\nPETS\n</div>', 'two steps forward, one step back'),
    question.new('<div style="font-family: monospace">\nSAILING\n<br>\nC C C C C C C\n</div>', 'sailing on the seven seas'),
    question.new('<div style="font-family: monospace">\nT<br>O<br>W<br>N\n</div>', 'downtown'),
    question.new('<p style="font-family: monospace">MIL1LION</p>', 'one in a million'),
    question.new('<div style="font-family: monospace">\nLITTLE LITTLE\n<br>\nLATE LATE\n</div>', 'too little, too late'),
    question.new('<div style="font-family: monospace">\nX&nbsp;&nbsp;I&nbsp;ST\n<br>\nN\n<br>\nG\n</div>', '10 Downing Street'),
    question.new('<p style="font-family: monospace">ABCDEFGHIJKLMNOPQRSTVWXYZ</p>', 'missing you'),
    question.new('<div style="font-family: monospace">\nGROUND\n<br>\nFEET FEET\n<br>\nFEET FEET\n<br>\nFEET FEET\n</div>', 'six feet underground'),
  ]),
  local palindromes = round.new('Palindromes', 'Every answer is a palindrome, spelled the same forwards as backwards. For example, "racecar".').withQuestions([
    question.new('The name of the exercise in which one hangs from a bar and lifts oneself up by the arms.', 'pullup'),
    question.new('A type of indian bread', 'naan'),
    question.new('The first name of the school bus driver in _The Simpsons_', 'Otto'),
    question.new('A word to describe something being more of a particular primary colour', 'redder'),
    question.new('Another name for midday', 'noon'),
    question.new('A tool that features a bubble in liquid', 'level'),
    question.new('A type of narrow boat propelled by means of a double-bladed paddle', 'kayak'),
    question.new('The name of the detection system that uses radio waves.\nOften used in speed guns.', 'radar'),
  ]),
  local pictures = round.new('Pictures', 'Guess the TV show from the picture').withQuestions([
    question.new('![](https://www.arabnews.com/sites/default/files/styles/n_670_395/public/2019/09/07/1744581-1920341972.jpg?itok=31XU_kyJ)', 'Friends'),
    question.new('![](https://www.denofgeek.com/wp-content/uploads/2017/08/we-bare-bears-episodic.png?resize=768%2C432)', 'We Bare Bears'),
    question.new('![](https://images.squarespace-cdn.com/content/v1/57558164f85082f641ddd335/1471502948631-TOSVL254NSE7FABWZ8YH/ke17ZwdGBToddI8pDm48kJ1oJoOIxBAgRD2ClXVCmKFZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpziSlY8A1LmVReJFCynOXqeaWYLb3HWLzCmFZz9oDHtK-zoXiGli2Az6uRt_tQQ38k/%27Life+On+Mars%27-+INT+CID+Set.jpg?format=1000w)', 'Life On Mars'),
    question.new('![](https://i0.wp.com/metro.co.uk/wp-content/uploads/2020/03/PRI_140307856-2.jpg?quality=90&strip=all&zoom=1&resize=540%2C413&ssl=1)', 'Tiger King'),
    question.new('![](https://upload.wikimedia.org/wikipedia/en/b/b2/Ba4.jpg)', 'Blackadder'),
    question.new('![](https://twt-thumbs.washtimes.com/media/image/2019/05/14/Arthur_PBS_c55-0-1344-752_s885x516.jpg?376641c3e4c2400c5e082ae69a3205f78c5380bc)', 'Arthur'),
    question.new('![](https://upload.wikimedia.org/wikipedia/en/5/51/Dadsarmy_1.jpg)', "Dad's Army"),
    question.new('![](https://cdn.vox-cdn.com/thumbor/L3eUuThaU0J5McgLVpswW8MdirU=/0x0:2182x1348/920x613/filters:focal(1093x412:1441x760):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/57166113/heyarnold.0.png)', 'Hey Arnold'),
    question.new('![](http://d2buyft38glmwk.cloudfront.net/media/cms_page_media/2014/11/6/DA6_-Season_Release_655x300.jpg)', 'Downton Abbey'),
    question.new('![](https://i0.wp.com/metro.co.uk/wp-content/uploads/2018/03/ay_35038361.jpg?quality=90&strip=all&zoom=1&resize=644%2C514&ssl=1)', 'Doctor Who'),
  ]),
  local general = round.new('General Knowledge', 'Random trivia!').withQuestions([
    question.new('In what year was the first Toy Story released?', 1995),
    question.new('What colors make up the olympic rings?', 'red, yellow, green, blue, black'),
    question.new('What is the closest prime number to 100?', 101),
    question.new('What is the largest planet in our solar system?', 'Jupiter'),
    question.new('Can you name three actors that have played Batman?', 'Lewis G. Wilson, Robert Lowery, Adam West, Michael Keaton, Val Kilmer, George Clooney, Christian Bale, Will Arnett, Ben Affleck'),
    question.new('What is the first element in the periodic table?', 'Hydrogen (H)'),
    question.new('How many points is the letter _M_ worth in Scrabble?', 'three'),
    question.new('In sailing, does _starboard_ refer to the left or the right?', 'right'),
    question.new('Who wrote the novel _Nineteen Eighty-Four_?', 'George Orwell'),
  ]),
  local songs = round.new('Songs', 'Guess the song from the first two lines').withQuestions([
    question.new("Common love isn't for us.\n\nWe created something phenomenal", 'Physical, Dua Lipa'),
    question.new('Baby, I like your style.\n\nGrips on your waist.', 'One Dance, Drake'),
    question.new('I remember when.\n\nI remember, I remember when I lost my mind.', 'Crazy, Gnarles Barkley'),
    question.new("Load up on guns, bring your friends.\n\nI's fun to lose and to pretend.", 'Smells Like Teen Spirit, Nirvana'),
    question.new("It's like a jungle sometimes.\n\nIt makes me wonder how I keep from goin under.", 'The Message, Grandmaster Flash'),
    question.new("When you're weary, feeling small.\n\nWhen tears are in your eyes, I will dry them all.", 'Bridge over Troubled Water, Simon and Garfunkel'),
    question.new('I thought love was only true in fairy tales.\n\nMeant for someone else but not for me.', 'Believer, The Monkees'),
    question.new('You shake my nerves and you rattle my brain.\n\nToo much love drives a man insane.', 'Great Balls of Fire, Jerry Lee Lewis'),
    question.new("I'm dreaming of a white Christmas\n\nJust like the ones I used to know", 'White Christmas, Bing Crosby'),
    question.new('Have you seen the well to do.\n\nUp and down Park Avenue.', "Puttin' on the Ritz, Fred Astaire"),
  ]),
  local specialist = round.new('Specialist', "Minus one point if you don't get your specialist question right!").withQuestions([
    question.new('Hannah:\n\nThe dance fitness class known as Zumba was invented by a man from which country?', 'Colombia'),
    question.new('Tad:\n\nAccording to RetroWow, what is the best selling car of the 1970s?', 'Ford Cortina'),
    question.new("Jake:\n\nWhat song features the chorus _No matter what I do, all I can think about is you. Even when I'm with my boo, boy you know I'm crazy over you?_", 'Dilemma'),
    question.new('Sarah:\n\nIn the song "_No Woman, No Cry_", Bob Marley reminisces about sitting in the government yard of which town?', 'Trenchtown'),
    question.new('Rod:\n\nHow many miles long is a marathon to three significant figures?', 26.2),
    question.new('Scarlett:\n\nWhat colour is Sonic the Hedgehog?', 'blue'),
    question.new("Emili:\n\nWhat was the name of Rodney's trilby wearing best friend?", 'Mickey Pierce'),
    question.new('Nana:\n\nCan you name four of the five of the oceans of the world?', 'Indian, Pacific, Atlantic, Arctic, Southern'),
    question.new('Aaron:\n\nIn which English city is _Peaky Blinders_ set?', 'Birmingham'),
    question.new('Ema:\n\nWho is the current presenter of _Antiques Roadshow_?', 'Fiona Bruce'),
  ]),
  local scavenger = round.new('Scavenger Hunt', 'First one to return with the item described gets the point!').withQuestions([
    question.new('Something the size of a mouse', ''),
    question.new('Something beginning with the letter _A_', ''),
    question.new('Something that comes as a pair', ''),
    question.new('Something you sleep with', ''),
    question.new('Something that moves', ''),
    question.new('Something you have stockpiled', ''),
    question.new("Something you couldn't live without", ''),
    question.new('Something with spots on it', ''),
    question.new('An onion', ''),
    question.new('Something health', ''),
  ]),
  'index.md': q.withRounds([dingbats, palindromes, pictures, general, songs, specialist, scavenger]).renderMarkdown(),
}
