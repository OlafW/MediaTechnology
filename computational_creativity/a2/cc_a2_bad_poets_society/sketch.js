let riMarkov, data;
let elfje = [];

const stanza = [1, 2, 3, 4, 1];
const maxTries = 50;

let firstPress = false;
let startGeneration = false;
let showGeneratingText = false;


//------------Parameter Settings------------------//

/*
    N_Markov: the length of each n-gram stored in the RiMarkov model
    Possible values: (2-10)
*/
const N_Markov = 5;

/*
    completionContexts: determines what to take into account when generating a new sentence
    - ALL: all lines generated so far
    - PREV_SENTENCE: only the previous sentence
    - LAST_WORD: only the last word of the previous sentence
*/
const completionContexts = ["ALL", "PREV_SENTENCE", "LAST_WORD"];
const setContext = completionContexts[2];

//-----------------------------------------------//



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
    let unwantedLastPos = ["dt", "vbz", "vbp", "to", "cc", "in", "prp$", "cd"];

    for (let i = 0; i < stanza.length; i++) {
        let line;
        let tries = 0;
        let failedCompletion = false;

        if (i > 0) {
            let completionContext;

            switch (setContext) {
                case "ALL":
                completionContext = elfje.join(' ');
                break;

                case "PREV_SENTENCE":
                completionContext = elfje[i-1];
                break;

                case "LAST_WORD":
                let prevTokens= RiTa.tokenize(elfje[i-1]);

                if (i == 4) completionContext = prevTokens[prevTokens.length-2];
                else        completionContext = prevTokens[prevTokens.length-1];

                break;
            }

            line = generateNumWordsFromCompletion(stanza[i], completionContext);

            if (line == -1) {
                failedCompletion = true;
            }
            else {
                let last_token = RiTa.tokenize(line).length-1;

                while (containsUnwantedPos(line, [last_token], unwantedLastPos) &&
                       tries < maxTries && !failedCompletion) {
                    line = generateNumWordsFromCompletion(stanza[i], completionContext);

                    if (line == -1) failedCompletion = true;
                    tries++;
                }
            }
        }

        if (tries >= maxTries) {
            failedCompletion = true;
            print("too many tries for", i, "at completion()");
        }
        tries = 0;

        if (i == 0 || failedCompletion) {
            if (failedCompletion) {
                print("Failed completion at line " + i);
            }

            line = generateNumWords(stanza[i]);
            let last_token = RiTa.tokenize(line).length-1;

            while (containsUnwantedPos(line, [last_token], unwantedLastPos) && tries < maxTries) {
                line = generateNumWords(stanza[i]);
                tries++;
            }
        }
        if (tries >= maxTries) print("too many tries for ", i, "at generate() ");


        if (i == 3) {
            if (RiTa.isPunctuation(line.charAt(line.length-1))) {
                line = RiString(line).replaceChar(line.length-1, "?").text();
            }
            else if (!line.endsWith("?")) line += "?";
        }

        line = line.replaceAll(".", ",");
        elfje[i] = line;
    }

   for (let i = 0; i < elfje.length; i++) {
        elfje[i] += "\n";
    }
}

function containsUnwantedPos(sentence, tokens=[], unwantedPos) {
    if (tokens.length == 0) {
        for (let i = 0; i < sentence.length; i++) {
            tokens[i] = i;
        }
    }

    let pos = RiTa.getPosTags(sentence);
    let contains_pos = false;

    for (let i = 0; i < tokens.length; i++) {
        for (let j = 0; j < unwantedPos.length; j++) {

            if (pos[tokens[i]] == unwantedPos[j]) {
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

    while ((RiTa.tokenize(RiTa.stripPunctuation(words)).length != N ||
            (words == "" || words == " ")) && tries < maxTries) {

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

    let words = " ";
    let tries = 0;
    // if (completions.length == 0) print("stop at first try");

    while ((RiTa.tokenize(RiTa.stripPunctuation(words)).length != N || (words == "" || words == " ")) &&
            tries < maxTries && completions.length > 0) {

        let rw = int(pow(random(1), 2) * completions.length);
        let w = completions[rw];
        w = completions[0];

        if (RiTa.isPunctuation(w)) {
            let wordsTokenized = RiTa.tokenize(words);
            let tokenStripped = RiTa.tokenize(RiTa.stripPunctuation(words));

            if (!RiTa.isPunctuation(wordsTokenized[wordsTokenized.length-1]) &&
                tokenStripped != "") {

                words += w;
            }
        }
        else words += " " + w;


        tokens = RiTa.tokenize(RiTa.stripPunctuation(words));
        // tokens = RiTa.tokenize(RiTa.stripPunctuation(prevLine + words));

        completions = riMarkov.getCompletions(tokens);

        // if (completions.length == 0) print("stop at", tries);
        tries++;
    }

    if (RiTa.tokenize(RiTa.stripPunctuation(words)).length != N ||
        words == "" || words == " " || tries >= maxTries) {
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

    fill(0);
    noStroke();
    textAlign(CENTER, CENTER);

    if (!firstPress) {
        textSize(30);
        textStyle(ITALIC);

        let introText = "manuals...\n" +
                        "they exist\n" +
                        "for every click\n" +
                        "Is it clear now?\n" +
                        "confusion\n";

        text(introText, width/2, height/2);
    }

    else if (showGeneratingText && !startGeneration) {
        textSize(30);
        textStyle(ITALIC);
        text("generating....", width/2, height/2);
        startGeneration = true;
    }

    else if (startGeneration) {
        generateElfje();

        showGeneratingText = false;
        startGeneration = false;
    }

    else {
        textSize(40);
        textStyle(NORMAL);
        text(elfje.join(' '), width/2, height/2);
    }
}

function mousePressed() {
    firstPress = true;
    showGeneratingText = true;
}
