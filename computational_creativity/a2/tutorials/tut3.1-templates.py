from random import choice

def exersize1():
  spring_attribute = ['worn out sandals', 'cucumber sweat', 'icecream on a man\'s shirt',
                      'melting sleep', 'white legs', 'a day of day', 'no jacket'
                      ]

  winter_attribute = ['pumpkin', 'dim table lighting', 'thoughts about the moon',
                      '4 hours of beef stew on a sunday afternoon', 'a day of night',
                      'lit up living rooms'
                     ]


  spring_activity = ['chlorine diving', 'cicadas eating silence', 'wanting to go outside']

  winter_activity = ['snow eating all sound', 'full month\'s sleep', 'staying inside']

  return ('\n' +
    'Hello Spring.\n' +
    'Goodbye Winter.\n' +
    'Hello ' + choice(spring_attribute) + '.\n' +
    'Goodbye ' + choice(winter_attribute) + '.\n' +
    'Hello ' + choice(spring_activity) + '.\n' +
    'Goodbye ' + choice(winter_activity) + '.\n')


print(exersize1())
