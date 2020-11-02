let riMarkov, data;

const N_Markov = 4;

let stanza = [1, 2, 3, 4, 1];
let elfje = [];
let maxTries = 50;

let firstPress = false;

function preload() {
    data = loadStrings("./data/manual1.txt");
}

function setup() {
  createCanvas(windowWidth, windowHeight);
  textFont('times');
  rectMode(CENTER);

  data = join(data, ' ');

  riMarkov = new RiMarkov(N_Markov);
  riMarkov.loadText(data);
}


function generateElfje() {
    for (let i = 0; i < stanza.length; i++) {
        let line;
        let tries = 0;
        let failedCompletion = false;

        let completionContext = elfje.join(' ');
        // let completetionContext = elfje[i-1];

        if (i > 0) {
            line = generateNumWordsFromCompletion(stanza[i], completionContext);
            if (line == -1) {
                failedCompletion = true;
            }
            else {
                let last_token = RiTa.tokenize(line).length-1;

                while (containsUnwantedPos(line, [last_token]) && tries < maxTries && !failedCompletion) {
                    line = generateNumWordsFromCompletion(stanza[i], completionContext);

                    if (line == -1) failedCompletion = true;
                    tries++;
                }
            }
        }
        tries = 0;

        if (i == 0 || failedCompletion) {
            line = generateNumWords(stanza[i]);
            let last_token = RiTa.tokenize(line).length-1;

            while (containsUnwantedPos(line, [last_token]) && tries < maxTries) {
                line = generateNumWords(stanza[i]);
                tries++;
            }
        }

        line = line.replaceAll(".", ",");

        if (tries >= maxTries) print("too many tries for ", i);
        tries = 0;

        if (i == 3) {
            if (RiTa.isPunctuation(line.charAt(line.length-1))) {
                line = RiString(line).replaceChar(line.length-1, "?").text();
            }
            else if (!line.endsWith("?")) line += "?";
        }

        // else if (i == 4) {
        //     let oneLiner = RiTa.stripPunctuation(elfje[3]);
        //     let completions = riMarkov.getCompletions(RiTa.tokenize(oneLiner));
        //
        //     for (let i = 0; i < completions.length; i++) {
        //         let c = completions[i];
        //         let pos = RiTa.getPosTags(c);
        //
        //         if (/nn.*/.test(pos) || pos == "jj" ||
        //             pos == "rb" || tries >= maxTries) {
        //             line = c.toLowerCase();
        //             // print(line);
        //             break;
        //         }
        //         tries++;
        //     }
        // }

        if (tries >= maxTries) print("too many tries for ", i);

        elfje[i] = line;
    }

   for (let i = 0; i < elfje.length; i++) {
        elfje[i] += "\n";
    }
}


function containsUnwantedPos(sentence, tokens=[]) {
    if (tokens.length == 0) {
        for (let i = 0; i < sentence.length; i++) {
            tokens[i] = i;
        }
    }

    let unwantedPos = ["dt", "vbz", "vbp", "to", "cc", "in", "prp$", "."];
    let contains_pos = false;

    let pos = RiTa.getPosTags(sentence);
    let token = RiTa.tokenize(sentence);

    for (let i = 0; i < tokens.length; i++) {
        for (let j = 0; j < unwantedPos.length; j++) {
            if (pos[tokens[i]] == unwantedPos[j]) {
                // print(token[tokens[i]]);
                contains_pos = true;
                break;
            }
        }
    }
    return contains_pos;
}


function generateNumWords(N) {
    let words = " ";
    let tries = 0;

    while ((RiTa.tokenize(words).length != N || (words == "" || words == " ")) && tries < maxTries) {
        words = riMarkov.generateTokens(N);
        words = RiTa.untokenize(words);
        words = RiTa.trimPunctuation(words);
        tries++;
    }
    if (tries >= maxTries) print("too many tries for generateNumWords()");

    words = words.toLowerCase();
    return words;
}

function generateNumWordsFromCompletion(N, prevLine) {
    let tokens = RiTa.tokenize(RiTa.stripPunctuation(prevLine));
    let completions = riMarkov.getCompletions(tokens);

    let words = "";
    let tries = 0;

    while (tries < maxTries && completions.length > 0 &&
           (RiTa.tokenize(words).length != N || (words == "" || words == " "))) {

        let rw = int(pow(random(1), 2) * completions.length);
        let w = completions[rw];

        if (w != ".") {
            if (RiTa.isPunctuation(w)) {
                words += w;
            }
            else words += " " + w;
        }

        words = RiTa.trimPunctuation(words);
        // print(prevLine + words);

        tokens = RiTa.tokenize(RiTa.stripPunctuation(prevLine + words))
        completions = riMarkov.getCompletions(tokens);

        tries++;
    }

    if (RiTa.tokenize(words).length != N) {
        print("FAILED: generateNumWordsFromCompletion()");
        return -1;
    }
    else {
        words = words.trim();
        words = words.toLowerCase();
        return words;
    }
}


function draw() {
    background(255);

    // noFill();
    // stroke(0);
    // rect(width/2, height/2, 500, 500);

    fill(0);
    noStroke();
    textSize(40);
    textAlign(CENTER, CENTER);

    if (!firstPress) {
        textSize(30);
        text("Click to generate a new Elfje", width/2, height/2);
    }
    else {
        text(elfje.join(' '), width/2, height/2);
    }
}

function mousePressed() {
    generateElfje();
    firstPress = true;
}
