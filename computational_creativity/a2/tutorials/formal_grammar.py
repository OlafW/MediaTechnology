
ruleset = [["S", "aSb"], ["S", "ba"]]

sentence = "S"

for n in range(2):
  for r in ruleset:
    print(sentence)

    for l in sentence:
        if l in r:
          sentence = sentence.replace(l, r[1])
