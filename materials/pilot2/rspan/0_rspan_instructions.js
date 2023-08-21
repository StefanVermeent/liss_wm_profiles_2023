//-------------------- Welcome
var rspan_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Je gaat nu beginnen aan het <b>Pijlen en Letters</b> spel!"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {
    task: "rspan_welcome",
    variable: 'welcome'}
};


//-------------------- Instructions

var rspan_instructions_arrows = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //Page 1
        "<p style = 'text-align: center;'>"+
          "In dit spel zul je steeds twee dingen moeten doen:<br><br>" +
          "1. De richting van <strong>pijlen</strong> onthouden.<br>" +
          "2. Bepalen of letters <strong>gespiegeld</strong> zijn.",

        //page 2
        "<p style = 'text-align: center;'>"+
          "<strong>Taak 1: Pijlen onthouden</strong><br><br>" +
          "Je krijgt &#233;&#233;n voor &#233;&#233;n een paar pijlen te zien.<br>" +
          "Jouw taak is om alle pijlen <strong>in de juiste volgorde</strong> te onthouden.<br>" +
          "Een klein voorbeeld: Je krijgt eerst een '<strong>pijl omhoog</strong>' te zien, dan een '<strong>pijl naar links</strong>', en tot slot een '<strong>pijl rechts naar beneden</strong>'.<br><br><br>" +
          "<img width = 250 src = rspan/img/instr01.png></img><br><br>",

        //page 5

          "Na afloop klik je op de pijlen <strong>in de juiste volgorde</strong>.<br><br>" +
          "Gebruik de '<strong>?</strong>' knop als je een pijl bent vergeten.<br>" +
          "Gebruik de '<strong>corrigeer</strong>' knop om je antwoord aan te passen.<br><br><br>" +
          '<img width = 250 src = rspan/img/instr02.png></img><br><br>',

          "Het is normaal als je niet alle pijlen kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, je mobiel, of je vingers.<br>" +
          "Je mag de pijlen wel hardop of in je hoofd herhalen.<br><br>"
      ],
      show_clickable_nav: true,
      allow_backward: true,
      key_forward: -1,
      key_backward: -1,
      button_label_next: "verder",
      button_label_previous: "ga terug",
      data: {
        task: "rspan_instructions",
        variable: 'instruction'
      }
    },

    {
      type: jsPsychHtmlKeyboardResponse,
      stimulus: "<p style = 'text-align: center;'>"+
        "We zullen deze taak nu eerst 3 keer oefenen.<br><br>" +
        "Druk op een willekeurige toets op je toetsenbord als je klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};


var rspan_instructions_rotation = {
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
          "<strong>Taak 2: Gespiegelde Letters</strong><br><br>" +
          "Op de tweede taak zul je &#233;&#233;n voor &#233;&#233;n steeds een 'G', 'F', of 'R' zien.<br><br>Soms zijn de letters <strong>normaal</strong>, zoals hieronder:<br>" +
          "<img src=" + '"rspan/img/g_0_normal.png">' + "<br>",

        //page 3
        "<p style = 'text-align: center;'>"+
          "Soms zijn de letters <strong>gespiegeld</strong>, zoals hieronder:<br>" +
          "<img src=" + '"rspan/img/g_0_mirror.png"' + "><br>",

        //page 4
        "<p style = 'text-align: center;'>"+
          "Jouw taak is om te bepalen of de letter <strong><span style = 'color: green;'>NORMAAL</span></strong> of <strong><span style = 'color: red;'>GESPIEGELD</span></strong> is.<br><br><br>" +
          "<div style = 'float: left;'>Als de letter <strong><span style = 'color: green;'>NORMAAL</span></strong> is,<br>druk dan op de '<strong>A</strong>' toets<br>op je toetsenbord.<br>" + "<img src=" + '"rspan/img/f_0_normal.png">' + "</div>" +
          "<div style = 'float: right;'>Als de letter <strong><span style = 'color: red;'>GESPIEGELD</span></strong> is,<br>druk dan op de '<strong>L</strong>' toets<br>op je toetsenbord.<br>" + "<img src=" + '"rspan/img/f_0_mirror.png">' + "</div><br><br><br>",

        //page 5
         "<p style = 'text-align: center;'>"+
         "Om het lastiger te maken zijn de letters soms (deels) gedraaid.<br>" +
         "Hieronder zie je voorbeelden van een  <strong>normale</strong> 'R' en een <strong>gespiegelde</strong> 'R' die allebei gedraaid zijn:<br>" +
         "<div style = 'float: left;'><strong><span style = 'color: green;'>NORMAAL</span></strong><br><img src=" + '"rspan/img/r_315_normal.png">' + "</div>" +
         "<div style = 'float: right;'><strong><span style = 'color: red;'>GESPIEGELD</span></strong><br><img src=" + '"rspan/img/r_225_mirror.png">' + "</div><br><br><br><br>",

         //page 6
         "<p style = 'text-align: center;'>" +
         "Je moet de letter soms dus eerst in je hoofd omdraaien voordat je kunt bepalen of hij gespiegeld is.<br>" +
         "<div style = 'float: left;'><strong><span style = 'color: green;'>NORMAAL</span></strong><br><img src=" + '"rspan/img/f_180_normal.png">' + "</div>" +
         "<div style = 'float: right;'><strong><span style = 'color: red;'>GESPIEGELD</span></strong><br><img src=" + '"rspan/img/r_270_mirror.png">' + "</div><br><br><br><br>",

      ],
      show_clickable_nav: true,
      allow_backward: true,
      key_forward: -1,
      key_backward: -1,
      button_label_next: "verder",
      button_label_previous: "ga terug",
      data: {
        task: "rspan_instruction",
        variable: 'instruction'
      }
    },

    {
      type: jsPsychHtmlKeyboardResponse,
      stimulus: "<p style = 'text-align: center;'>"+
        "We zullen deze taak nu eerst 8 keer oefenen.<br><br>" +
        "Plaats je vingers op de '<strong>A</strong>' en '<strong>L</strong>' toetsen op je toetsenbord en druk op een willekeurige toets op je toetsenbord als je klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};

var rspan_instructions_full = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //page 1
        "<p style = 'text-align: center;'>"+
          "Goed gedaan!<br><br>" +
          "We gaan nu de volledige taak oefenen.",

        //page 2
        "<p style = 'text-align: center;'>"+
          "In het volledige spel moet je <strong>snel wisselen</strong> tussen de twee taken<br>die je net hebt geoefend.<br><br><br>" +
          "Je ziet eerst een pijl, dan een letter, dan een pijl, dan een letter, enzovoort:<br><br><br>" +
          "<img width = 400 src = rspan/img/instr03.png></img><br><br>",

        //page 3

        "<p style = 'text-align: center;'>" +
          "Nadat je alle pijlen en letters hebt gezien,<br>selecteer je de pijlen die je hebt gezien <strong>in de juiste volgorde</strong>.",

        //page 4
        "<p style = 'text-align: center;'>"+
          "Het is belangrijk dat je je best doet op beide taken!<br>" +
          "Probeer de pijlen zo goed mogelijk te onthouden,<br>en probeer zo goed mogelijk te bepalen of de letters gespiegeld zijn.<br><br>",

        //page 5
        "<p style = 'text-align: center;'>"+
          "Het is normaal als je niet alle pijlen kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, je mobiel, of je vingers.<br>" +
          "Je mag de pijlen wel hardop of in je hoofd herhalen.<br><br>"
      ],
      show_clickable_nav: true,
      allow_backward: true,
      key_forward: -1,
      key_backward: -1,
      button_label_next: "verder",
      button_label_previous: "ga terug",
      data: {
        task: "rspan_instructions",
        variable: 'instruction'
      }
    },

    {
      type: jsPsychHtmlKeyboardResponse,
      stimulus: "<p style = 'text-align: center;'>"+
        "We zullen de volledige taak nu eerst 3 keer oefenen.<br><br>" +
        "Druk op een willekeurige toets op je toetsenbord als je klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};

var rspan_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>"+
    "Je bent nu klaar voor de echte taak.<br><br>" +
    "De taak bestaat uit 12 rondes.<br>" +
    "Vanaf nu krijg je geen feedback meer op je prestaties.<br><br>" +
    "Druk op een willekeurige toets op je toetsenbord om te beginnen.",
  choices: "ALL_KEYS",
  data: {
    task: "rspan_start",
    variable: 'rspan_start'
  },
};



var rspan_end = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>"+
      "Dit is het einde van de <strong>Pijlen en Letters</strong> taak.<br>" +
      "Klik op 'verder' om door te gaan.",
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  button_label_previous: "ga terug",
  data: {
    task: "rspan_end",
    variable: 'rspan_end'
  }
};
