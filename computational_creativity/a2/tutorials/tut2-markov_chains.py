import random
import pprint

states = ['the', 'cat', 'is', 'fat']
prior = [0.9, 0.4, 0.2, 0.9]

trans_matrix = [
  [
    [0, 0.7, 0.1, 0.2],
    [0.1, 0.0, 0.7, 0.2],
    [0.2, 0.1, 0.0, 0.7],
    [0.7, 0.0, 0.3, 0.0]
  ],
  [
    [0.0, 0.7, 0.1, 0.2],
    [0.1, 0.0, 0.7, 0.2],
    [0.2, 0.1, 0.0, 0.7],
    [0.7, 0.0, 0.3, 0.0]
  ]
]

sentence = random.choices(states, weights = prior)

N = len(states)-1
for n in range(N):
  current_state = states.index(sentence[n])
  sentence += random.choices(states, weights = trans_matrix[current_state])

pprint.PrettyPrinter(depth=3,indent=4).pprint(trans_matrix[0])
