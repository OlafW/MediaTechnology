let json, animals;

function preload() {
  json = loadJSON('data/common.json');
}

function setup() {
  createCanvas(screen.width, screen.height);

  animals = json.animals;
  textAlign(CENTER, BOTTOM);
  textSize(50);
}

function draw() {
  background(220);
  let lines = stanza();
  if (lines != -1) {
    text(lines, width / 2, height / 2);
  }
  frameRate(0.25);
}

function stanza() {
  let house = random(['Gryffindor', 'Ravenclaw', 'Hufflepuff', 'Slytherin']);

  let animal1 = random(animals);
  let tries = 0;
  let maxTries = 100;

  while (countSyllables(animal1) != 3 && tries < maxTries) {
    animal1 = random(animals);
    tries++;
  }

  let animal2;
  let rhyhming_adjs = [];
  tries = 0;

  while (rhyhming_adjs.length == 0 && tries < maxTries) {
    animal2 = random(animals);
    while (countSyllables(animal2) != 1 && tries < maxTries) {
      animal2 = random(animals);
      tries++;
    }

    let rhyming_words = RiTa.rhymes(animal2);

    for (let i = 0; i < rhyming_words.length; i++) {
      if (isAdjective(rhyming_words[i])) {
        rhyhming_adjs.push(rhyming_words[i]);
      }
    }
    tries++;
  }
  if (tries >= maxTries) {
    return -1;
  }

  else {
    adj = random(rhyhming_adjs);

    // replace adj with an adjective with 1 syllable rhyming with animal2
    // 1. check out the RiTa.rhymes() function to get rhyming words
    // 2. use the isAdjective() function (below) to filter rhyming words
    // 3. choose a random rhyming adjective and/or check one exists
    // 4. if no rhyming adjective found, try choosing a different animals2

    return "The body of " + a(animal1) +
      ", the wisdom of " + a(animal2) + "\n" +
      "I'm putting you in " + house +
      " for you are really " + adj;
  }
}

function countSyllables(word) {
  return RiTa.getSyllables(word).split(/\//).length;
}

function a(word) {
  var result = 'a';
  var firstPhoneme = RiTa.getPhonemes(word)[0];
  if (['a', 'e', 'i', 'o', 'u'].includes(firstPhoneme)) {
    result = 'an';
  }
  return result + ' ' + word;
}

function isAdjective(word) {
  // return true if word is tagged 'jj' (adjective)
  return RiTa.getPosTags(word)[0] === 'jj';
}
