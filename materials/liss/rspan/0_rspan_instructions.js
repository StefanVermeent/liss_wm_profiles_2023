//-------------------- Welcome
var rspan_welcome = {
  type: jsPsychInstructions,
  pages: [
    "U gaat nu beginnen aan het <b>Pijlen en Letters</b> spel!"
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
          "In dit spel zult u steeds twee dingen moeten doen:<br><br>" +
          "1. De richting van <strong>pijlen</strong> onthouden.<br>" +
          "2. Bepalen of letters <strong>gespiegeld</strong> zijn.",

        //page 2
        "<p style = 'text-align: center;'>"+
          "<strong>Taak 1: Pijlen onthouden</strong><br><br>" +
          "U krijgt &#233;&#233;n voor &#233;&#233;n een paar pijlen te zien.<br>" +
          "Uw taak is om alle pijlen <strong>in de juiste volgorde</strong> te onthouden.<br>" +
          "Een klein voorbeeld: U krijgt eerst een '<strong>pijl omhoog</strong>' te zien, dan een '<strong>pijl naar links</strong>', en tot slot een '<strong>pijl rechts naar beneden</strong>'.<br><br><br>" +
          "<img width = 250 src = rspan/img/instr01.png></img><br><br>",

        //page 5

          "Na afloop klikt u op de pijlen <strong>in de juiste volgorde</strong>.<br><br>" +
          "Gebruik de '<strong>?</strong>' knop als u een pijl bent vergeten.<br>" +
          "Gebruik de '<strong>corrigeer</strong>' knop om uw antwoord aan te passen.<br><br><br>" +
          '<img width = 250 src = rspan/img/instr02.png></img><br><br>',

          "Het is normaal als u niet alle pijlen kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, uw mobiel, of uw vingers.<br>" +
          "U mag de pijlen wel hardop of in uw hoofd herhalen.<br><br>"
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
        "Druk op een willekeurige toets op uw toetsenbord als u klaar bent om te oefenen.",
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
          "Op de tweede taak zult u &#233;&#233;n voor &#233;&#233;n steeds een <strong>G</strong>, <strong>F</strong>, of <strong>R</strong> zien.<br><br>Soms zijn de letters <strong>NORMAAL</strong>, zoals hieronder:<br>" +
          "<img src=" + '"rspan/img/g_0_normal.png">' + "<br>",

        //page 3
        "<p style = 'text-align: center;'>"+
          "Soms zijn de letters <strong>GESPIEGELD</strong>, zoals hieronder:<br>" +
          "<img src=" + '"rspan/img/g_0_mirror.png"' + "><br>",

        //page 4
        "<p style = 'text-align: center;'>"+
          "Uw taak is om te bepalen of de letter <strong><span style = 'color: green;'>NORMAAL</span></strong> of <strong><span style = 'color: red;'>GESPIEGELD</span></strong> is.<br><br><br>" +
          "<div style = 'float: left;'>Als de letter <strong><span style = 'color: green;'>NORMAAL</span></strong> is,<br>druk dan op de '<strong>A</strong>' toets<br>op uw toetsenbord.<br>" + "<img src=" + '"rspan/img/f_0_normal.png">' + "</div>" +
          "<div style = 'float: right;'>Als de letter <strong><span style = 'color: red;'>GESPIEGELD</span></strong> is,<br>druk dan op de '<strong>L</strong>' toets<br>op uw toetsenbord.<br>" + "<img src=" + '"rspan/img/f_0_mirror.png">' + "</div><br><br><br>",

        //page 5
         "<p style = 'text-align: center;'>"+
         "Om het lastiger te maken zijn de letters soms (deels) gedraaid.<br>" +
         "Hieronder ziet u voorbeelden van een  <strong>normale</strong> 'R' en een <strong>gespiegelde</strong> 'R' die allebei gedraaid zijn:<br>" +
         "<div style = 'float: left;'><strong><span style = 'color: green;'>NORMAAL</span></strong><br><img src=" + '"rspan/img/r_315_normal.png">' + "</div>" +
         "<div style = 'float: right;'><strong><span style = 'color: red;'>GESPIEGELD</span></strong><br><img src=" + '"rspan/img/r_225_mirror.png">' + "</div><br><br><br><br>",

         //page 6
         "<p style = 'text-align: center;'>" +
         "U moet de letter soms dus eerst in uw hoofd omdraaien voordat u kunt bepalen of hij gespiegeld is.<br>" +
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
        "Plaats uw vingers op de '<strong>A</strong>' en '<strong>L</strong>' toetsen op uw toetsenbord en druk op een willekeurige toets op uw toetsenbord als u klaar bent om te oefenen.",
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
          "In het volledige spel moet u <strong>snel wisselen</strong> tussen de twee taken<br>die u net hebt geoefend.<br><br><br>" +
          "U ziet eerst een pijl, dan een letter, dan een pijl, dan een letter, enzovoort:<br><br><br>" +
          "<img width = 400 src = rspan/img/instr03.png></img><br><br>",

        //page 3

        "<p style = 'text-align: center;'>" +
          "Nadat u alle pijlen en letters hebt gezien,<br>selecteert u de pijlen die u heeft gezien <strong>in de juiste volgorde</strong>.",

        //page 4
        "<p style = 'text-align: center;'>"+
          "Het is belangrijk dat u uw best doet op beide taken!<br>" +
          "Probeer de pijlen zo goed mogelijk te onthouden,<br>en probeer zo goed mogelijk te bepalen of de letters gespiegeld zijn.<br><br>",

        //page 5
        "<p style = 'text-align: center;'>"+
          "Het is normaal als u niet alle pijlen kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, uw mobiel, of uw vingers.<br>" +
          "U mag de pijlen wel hardop of in uw hoofd herhalen.<br><br>"
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
        "Druk op een willekeurige toets op uw toetsenbord als u klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};

var rspan_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>"+
    "U bent nu klaar voor de echte taak.<br><br>" +
    "De taak bestaat uit 12 rondes.<br>" +
    "Vanaf nu krijgt u geen feedback meer op uw prestaties.<br><br>" +
    "Druk op een willekeurige toets op uw toetsenbord om te beginnen.",
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
