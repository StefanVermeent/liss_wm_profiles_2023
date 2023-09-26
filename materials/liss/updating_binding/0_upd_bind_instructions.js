//-------------------- Welcome
var bind_upd_welcome = {
  type: jsPsychInstructions,
  pages: [
    "U gaat nu beginnen aan het <b>Geheugen</b> spel!"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {variable: 'welcome', task_version: "introduction"}
};


//-------------------- Instructions

// If participants start with the number version, they will be introduced with the task using numbers instead of colors.
var bind_upd_number_instructions = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //Page 1
        "<p style = 'text-align: center;'>" +
          "In dit spel ziet u een vierkant met negen vakjes, zoals hieronder.<br><br>" +
          "In de vakjes worden &#233;&#233;n voor &#233;&#233;n nummers getoond.<br>" +
          "Uw taak is om te onthouden welke nummer <strong>als laatste</strong> wordt getoond in een bepaald vakje.<br><br><br>" +
          "<img width = 250 src = updating_binding/img/instr01.png></img><br><br>",

        //page 2
        "<p style = 'text-align: center;'>"+
          "Soms wordt in elk vakje maar &#233;&#233;n nummer getoond.<br><br>" +
          "In het voorbeeld hieronder ziet u eerst een '<strong>6</strong>' midden-boven, dan een '<strong>2</strong>' linksonder, en tot slot een '<strong>9</strong>' linksmidden.<br>" +
          "De nummers die u moet onthouden zijn dus '<strong>6</strong>', '<strong>2</strong>', en '<strong>9</strong>'.<br><br><br>" +
          "<img width = 500 src = updating_binding/img/instr02.png></img><br><br>",

        //page 3
          "Soms worden meerdere nummers getoond in hetzelfde vakje.<br><br>" +
          "In het voorbeeld hieronder ziet u eerst een '<strong>0</strong>' rechtsmidden, dan een '<strong>3</strong>' linksboven, en tot slot een '<strong>5</strong>' rechtsmidden.<br>" +
          "In dit geval is de '<strong>0</strong>' vervangen door een '<strong>5</strong>'.<br>" +
          "De nummers die u moet onthouden zijn dus '<strong>3</strong>' en '<strong>5</strong>'.<br><br><br>" +
          '<img width = 500 src = updating_binding/img/instr03.png></img><br><br>',

          //page 4
          "Als alle nummers zijn getoond geeft u voor elk vakje aan welk nummer er <strong>als laatst</strong> werd getoond.<br>" +
          "U doet dit steeds voor het vakje met het <strong>vraagteken</strong> (?).<br><br>" +
          "Gebruik hiervoor de knoppen die onder het vierkant verschijnen.<br><br><br>" +
          '<img width = 600 src = updating_binding/img/instr04.png></img><br><br>',

        //page 5
          "Het is normaal als u niet alle nummers kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, uw mobiel, of uw vingers.<br>" +
          "U mag de nummers wel hardop of in uw hoofd herhalen.<br><br>"
      ],
      show_clickable_nav: true,
      allow_backward: true,
      key_forward: -1,
      key_backward: -1,
      button_label_next: "verder",
      button_label_previous: "ga terug",
      data: {variable: 'instruction', task_version: "introduction"}
    },

    {
      type: jsPsychHtmlKeyboardResponse,
      stimulus: "<p style = 'text-align: center;'>"+
        "We zullen dit spel nu eerst 4 keer oefenen.<br><br>" +
        "Druk op een willekeurige knop als u klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};


var bind_upd_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>"+
    "U bent nu klaar voor het echte spel.<br><br>" +
    "Het spel bestaat uit 18 rondes.<br>" +
    "Vanaf nu krijgt u geen feedback meer op uw prestaties.<br><br>" +
    "Druk op een willekeurige knop om te beginnen.",
  choices: "ALL_KEYS",
  data: {variable: 'bind_upd_start'},
};


var bind_upd_end = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>"+
      "Dit is het einde van het <strong>geheugenspel</strong>.<br>" +
      "Klik op 'verder' om door te gaan.",
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  button_label_previous: "ga terug",
  data: {variable: 'instruction', task_version: "introduction"}
};


