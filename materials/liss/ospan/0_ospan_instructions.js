//-------------------- Welcome
var ospan_welcome = {
  type: jsPsychInstructions,
  pages: [
    "U gaat nu beginnen aan het <b>Letters en Nummers</b> spel!"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {
    task: "ospan_welcome",
    variable: 'welcome'}
};


//-------------------- Instructions

// If participants start with the standard Ospan version, they will be introduced with the letter task in the standard visual appearance
var ospan_instructions_letters = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //Page 1
        "<p style = 'text-align: center;'>"+
          "In dit spel zult u steeds twee dingen moeten doen:<br><br>" +
          "1. <strong>Letters</strong> onthouden.<br>" +
          "2. Simpele <strong>rekensommen</strong> oplossen.",

        //page 2
        "<p style = 'text-align: center;'>"+
          "<strong>Taak 1: Letters onthouden</strong><br><br>" +
          "U krijgt &#233;&#233;n voor &#233;&#233;n een paar letters te zien.<br>" +
          "Uw taak is om alle letters <strong>in de juiste volgorde</strong> te onthouden.<br>" +
          "Een klein voorbeeld: U krijgt eerst een '<strong>S</strong>' te zien, dan een '<strong>Q</strong>', en tot slot een '<strong>F</strong>'.<br><br><br>" +
          "<img width = 250 src = ospan/img/instr01.png></img><br><br>",

        //page 5

          "Na afloop klikt u op de letters <strong>in de juiste volgorde</strong>.<br><br>" +
          "Gebruik de '<strong>?</strong>' knop als u een letter bent vergeten.<br>" +
          "Gebruik de '<strong>corrigeer</strong>' knop om uw antwoord aan te passen.<br><br><br>" +
          '<img width = 250 src = ospan/img/instr02.png></img><br><br>',

          "Het is normaal als u niet alle letters kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, uw mobiel, of uw vingers.<br>" +
          "U mag de letters wel hardop of in uw hoofd herhalen.<br><br>"
      ],
      show_clickable_nav: true,
      allow_backward: true,
      key_forward: -1,
      key_backward: -1,
      button_label_next: "verder",
      button_label_previous: "ga terug",
      data: {
        task: "ospan_instructions",
        variable: 'instruction'
      }
    },

    {
      type: jsPsychHtmlKeyboardResponse,
      stimulus: "<p style = 'text-align: center;'>"+
        "We zullen deze taak nu eerst 3 keer oefenen.<br><br>" +
        "Druk op een willekeurige toets op uw toetsenbord als u klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};


var ospan_instructions_math = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //Page 1
        "<p style = 'text-align: center;'>"+
          "Goed gedaan!<br><br>" +
          "We gaan nu door naar de tweede taak.",

        //page 2
        "<p style = 'text-align: center;'>"+
          "<strong>Taak 2:  Rekensommen oplossen</strong><br><br>" +
          "Op de tweede taak zult u simpele rekensommen zien zoals die hieronder:<br><br><br><br>" +
          "<div style = 'font-size:70px'>5 + 3 = 8</div><br><br><br>",

        //page 3
        "<p style = 'text-align: center;'>"+
          "Soms is de uitkomst van de rekensom <strong><span style = 'color: green;'>JUIST</span></strong>, zoals hieronder:<br><br><br><br>" +
          "<div style = 'font-size:70px'>5 + 3 = 8</div><br><br><br>",

        //page 4
        "<p style = 'text-align: center;'>"+
          "Soms is de uitkomst van de rekensom <strong><span style = 'color: red;'>ONJUIST</span></strong>, zoals hieronder:<br><br><br><br>" +
          "<div style = 'font-size:70px'>3 + 1 = 6</div><br><br><br>",

        //page 5
        "<p style = 'text-align: center;'>"+
          "Uw taak is om te bepalen of de uitkomst van de rekensom <strong><span style = 'color: green;'>JUIST</span></strong> of <strong><span style = 'color: red;'>ONJUIST</span></strong> is.<br><br>" +
          "<div style = 'float: left;'>Als de uitkomst <strong><span style = 'color: green;'>JUIST</span></strong> is,<br>druk dan op de '<strong>A</strong>' toets<br>op uw toetsenbord.</div>" +
          "<div style = 'float: right;'>Als de uitkomst <strong><span style = 'color: red;'>ONJUIST</span></strong> is,<br>druk dan op de '<strong>L</strong>' toets<br>op uw toetsenbord.</div><br><br><br><br>",
      ],
      show_clickable_nav: true,
      allow_backward: true,
      key_forward: -1,
      key_backward: -1,
      button_label_next: "verder",
      button_label_previous: "ga terug",
      data: {
        task: "ospan_instruction",
        variable: 'instruction'
      }
    },

    {
      type: jsPsychHtmlKeyboardResponse,
      stimulus: "<p style = 'text-align: center;'>"+
        "We zullen deze taak nu eerst 8 keer oefenen.<br><br>" +
        "Plaats uw vingers op de '<strong>A</strong>' en '<strong>L</strong>' toetsen op uw toetsenbord en druk op een willekeurige toets op uw toetsenbord als u klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};

var ospan_instructions_full = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //page 1
        "<p style = 'text-align: center;'>"+
          "Goed gedaan!<br><br>" +
          "We gaan nu het volledige spel oefenen.",

        //page 2
        "<p style = 'text-align: center;'>"+
          "In het volledige spel moet u <strong>snel wisselen</strong> tussen de twee taken<br>die u net heeft geoefend.<br><br><br>" +
          "U ziet eerst een letter, dan een rekensom, dan een letter, dan een rekensom, enzovoort:<br><br><br>" +
          "<img width = 400 src = ospan/img/instr03.png></img><br><br>",

        //page 3

        "<p style = 'text-align: center;'>" +
          "Nadat u alle letters en rekensommen heeft gezien,<br>selecteert u de letters die u heeft gezien <strong>in de juiste volgorde</strong>.",

        //page 4
        "<p style = 'text-align: center;'>"+
          "Het is belangrijk dat u uw best doet op beide taken!<br>" +
          "Probeer de letters zo goed mogelijk te onthouden,<br>en probeer de rekensommen zo snel en goed mogelijk op te lossen.<br><br>",

        //page 5
        "<p style = 'text-align: center;'>"+
          "Het is normaal als u niet alle letters kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, uw mobiel, of uw vingers.<br>" +
          "U mag de letters wel hardop of in uw hoofd herhalen.<br><br>"
      ],
      show_clickable_nav: true,
      allow_backward: true,
      key_forward: -1,
      key_backward: -1,
      button_label_next: "verder",
      button_label_previous: "ga terug",
      data: {
        task: "ospan_instructions",
        variable: 'instruction'
      }
    },

    {
      type: jsPsychHtmlKeyboardResponse,
      stimulus: "<p style = 'text-align: center;'>"+
        "We zullen het volledige spel nu eerst 3 keer oefenen.<br><br>" +
        "Druk op een willekeurige toets op uw toetsenbord als u klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};

var ospan_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>"+
    "U bent nu klaar voor het echte spel.<br><br>" +
    "De taak bestaat uit 9 rondes.<br>" +
    "Vanaf nu krijgt u geen feedback meer op uw prestaties.<br><br>" +
    "Druk op een willekeurige toets op uw toetsenbord om te beginnen.",
  choices: "ALL_KEYS",
  data: {
    task: "ospan_start",
    variable: 'ospan_start'
  },
};



var ospan_end = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>"+
      "Dit is het einde van het <strong>Letters en Nummers</strong> spel.<br>" +
      "Klik op 'verder' om door te gaan.",
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  button_label_previous: "ga terug",
  data: {
    task: "ospan_end",
    variable: 'ospan_end'
  }
};
