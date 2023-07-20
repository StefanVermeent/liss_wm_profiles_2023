//-------------------- Welcome
var bind_upd_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Je gaat nu beginnen aan het <b>Geheugen</b> spel!"
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
          "In dit spel zie je een vierkant met negen vakjes, zoals hieronder.<br><br>" +
          "In de vakjes worden &#233;&#233;n voor &#233;&#233;n nummers getoond.<br>" +
          "Jouw taak is om te onthouden welke nummer <strong>als laatste</strong> wordt getoond in een bepaald vakje.<br><br><br>" +
          "<img width = 250 src = updating_binding/img/instr01.png></img><br><br>",

        //page 2
        "<p style = 'text-align: center;'>"+
          "Soms wordt in elk vakje maar &#233;&#233;n nummer getoond.<br><br>" +
          "In het voorbeeld hieronder zie je eerst een '<strong>6</strong>' midden-boven, dan een '<strong>2</strong>' linksonder, en tot slot een '<strong>9</strong>' linksmidden.<br>" +
          "De nummers die je moet onthouden zijn dus '<strong>6</strong>', '<strong>2</strong>', en '<strong>9</strong>'.<br><br><br>" +
          "<img width = 500 src = updating_binding/img/instr02.png></img><br><br>",

        //page 3
          "Soms worden meerdere nummers getoond in hetzelfde vakje.<br><br>" +
          "In het voorbeeld hieronder zie je eerst een '<strong>0</strong>' rechtsmidden, dan een '<strong>3</strong>' linksboven, en tot slot een '<strong>5</strong>' rechtsmidden.<br>" +
          "In dit geval is de '<strong>0</strong>' vervangen door een '<strong>5</strong>'.<br>" +
          "De nummers die je moet onthouden zijn dus '<strong>3</strong>' en '<strong>5</strong>'.<br><br><br>" +
          '<img width = 500 src = updating_binding/img/instr03.png></img><br><br>',

          //page 4
          "Als alle nummers zijn getoond geef je voor elk vakje aan welk nummer er <strong>als laatst</strong> werd getoond.<br>" +
          "Je doet dit steeds voor het vakje met het <strong>vraagteken</strong> (?).<br><br>" +
          "Gebruik hiervoor de knoppen die onder het vierkant verschijnen.<br><br><br>" +
          '<img width = 600 src = updating_binding/img/instr04.png></img><br><br>',

        //page 5
          "Het is normaal als je niet alle nummers kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, je mobiel, of je vingers.<br>" +
          "Je mag de nummers wel hardop of in je hoofd herhalen.<br><br>"
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
        "We zullen deze taak nu eerst 4 keer oefenen.<br><br>" +
        "Druk op een willekeurige knop als je klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};


// If participants start with the color version, they will be introduced with the task using colors instead of numbers.
var bind_upd_color_instructions = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //Page 1
        "<p style = 'text-align: center;'>" +
          "In dit spel zie je een vierkant met negen vakjes, zoals hieronder.<br><br>" +
          "In de vakjes worden &#233;&#233;n voor &#233;&#233;n kleuren getoond.<br>" +
          "Jouw taak is om te onthouden welke kleur <strong>als laatste</strong> wordt getoond in een bepaald vakje.<br><br><br>" +
          "<img width = 250 src = updating_binding/img/instr01.png></img><br><br>",

        //page 2
        "<p style = 'text-align: center;'>"+
          "Soms wordt in elk vakje maar &#233;&#233;n kleur getoond.<br><br>" +
          "In het voorbeeld hieronder zie je eerst '<strong><font color='#000000'>ZWART</font></strong>' midden-boven, dan '<strong><font color='#117733'>GROEN</font></strong>' linksonder, en tot slot '<strong><font color = '#F357D9'>ROZE</font></strong>' linksmidden.<br>" +
          "De kleuren die je moet onthouden zijn dus '<strong><font color='#000000'>ZWART</font></strong>', '<strong><font color='#117733'>GROEN</font></strong>', en '<strong><font color = '#F357D9'>ROZE</font></strong>'.<br><br><br>" +
          "<img width = 500 src = updating_binding/img/instr05.png></img><br><br>",

        //page 3
          "Soms worden meerdere kleuren getoond in hetzelfde vakje.<br><br>" +
          "In het voorbeeld hieronder zie je eerst '<strong><font color='#888888'>GRIJS</font></strong>' rechtsmidden, dan '<strong><font color='#88CCEE'>BLAUW</font></strong>' linksboven, en tot slot '<strong><font color='#117733'>GROEN</font></strong>' rechtsmidden.<br>" +
          "In dit geval is '<strong><font color='#888888'>GRIJS</font></strong>' vervangen door '<strong><font color='#117733'>GROEN</font></strong>'.<br>" +
          "De kleuren die je moet onthouden zijn dus '<strong><font color='#88CCEE'>BLAUW</font></strong>' en '<strong><font color='#117733'>GROEN</font></strong>'.<br><br><br>" +
          '<img width = 500 src = updating_binding/img/instr06.png></img><br><br>',

          //page 4
          "Als alle kleuren zijn getoond geef je voor elk vakje aan welke kleur er <strong>als laatst</strong> werd getoond.<br>" +
          "Je doet dit steeds voor het vakje met het vraagteken.<br><br>" +
          "Gebruik hiervoor de knoppen die onder het vierkant verschijnen.<br><br><br>" +
          '<img width = 600 src = updating_binding/img/instr07.png></img><br><br>',

        //page 5
          "Het is normaal als je niet alle kleuren kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, je mobiel, of je vingers.<br>" +
          "Je mag de nummers wel hardop of in je hoofd herhalen.<br><br>"
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
        "We zullen deze taak nu eerst 4 keer oefenen.<br><br>" +
        "Druk op een willekeurige knop als je klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};


var bind_upd_number_to_color_transition = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //Page 1
        "<p style = 'text-align: center;'>" +
          "Goed gedaan!<br><br>" +
          "Je gaat nu een andere versie van deze taak doen met <strong>kleuren</strong> in plaats van nummers.<br>" +
          "Jouw taak blijft hetzelfde: Onthoud welke kleur <strong>als laatste</strong> wordt getoond in een bepaald vakje.<br><br><br>" +
          "<img width = 250 src = updating_binding/img/instr05.png></img><br><br>",

        //page 2
        "<p style = 'text-align: center;'>"+
          "In het voorbeeld hieronder zie je eerst '<strong><font color='#888888'>GRIJS</font></strong>' rechtsmidden, dan '<strong><font color='#88CCEE'>BLAUW</font></strong>' linksboven, en tot slot '<strong><font color='#117733'>GROEN</font></strong>' rechtsmidden.<br>" +
          "In dit geval is '<strong><font color='#888888'>GRIJS</font></strong>' vervangen door '<strong><font color='#117733'>GROEN</font></strong>'.<br>" +
          "De kleuren die je moet onthouden zijn dus '<strong><font color='#88CCEE'>BLAUW</font></strong>' en '<strong><font color='#117733'>GROEN</font></strong>'.<br><br><br>" +
          '<img width = 500 src = updating_binding/img/instr06.png></img><br><br>',


          //page 4
          "Als alle kleuren zijn getoond geef je voor elk vakje aan welke kleur er <strong>als laatst</strong> werd getoond.<br>" +
          "Je doet dit steeds voor het vakje met het vraagteken.<br><br>" +
          "Gebruik hiervoor de knoppen die onder het vierkant verschijnen.<br><br><br>" +
          '<img width = 600 src = updating_binding/img/instr07.png></img><br><br>',

        //page 5
          "Het is normaal als je niet alle kleuren kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, je mobiel, of je vingers.<br>" +
          "Je mag de kleuren wel hardop of in je hoofd herhalen.<br><br>"
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
        "We zullen deze versie van de taak nu eerst 2 keer oefenen.<br><br>" +
        "Druk op een willekeurige knop als je klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};



var bind_upd_color_to_number_transition = {
  timeline: [
    {
      type: jsPsychInstructions,
      pages: [
        //Page 1
        "<p style = 'text-align: center;'>" +
          "Goed gedaan!<br><br>" +
          "Je gaat nu een andere versie van deze taak doen met <strong>nummers</strong> in plaats van kleuren.<br>" +
          "Jouw taak blijft hetzelfde: Onthoud welk nummer <strong>als laatste</strong> wordt getoond in een bepaald vakje.<br><br><br>" +
          "<img width = 250 src = updating_binding/img/instr02.png></img><br><br>",

        //page 2
        "<p style = 'text-align: center;'>"+
          "In het voorbeeld hieronder zie je eerst een '<strong>0</strong>' rechtsmidden, dan een '<strong>3</strong>' linksboven, en tot slot een '<strong>5</strong>' rechtsmidden.<br>" +
          "In dit geval is de '<strong>0</strong>' vervangen door een '<strong>5</strong>'.<br>" +
          "De nummers die je moet onthouden zijn dus '<strong>3</strong>' en '<strong>5</strong>'.<br><br><br>" +
          '<img width = 500 src = updating_binding/img/instr03.png></img><br><br>',

          //page 4
          "Als alle nummers zijn getoond geef je voor elk vakje aan welk nummer er <strong>als laatst</strong> werd getoond.<br>" +
          "Je doet dit steeds voor het vakje met het vraagteken.<br><br>" +
          "Gebruik hiervoor de knoppen die onder het vierkant verschijnen.<br><br><br>" +
          '<img width = 600 src = updating_binding/img/instr04.png></img><br><br>',

        //page 5
          "Het is normaal als je niet alle nummers kunt onthouden.<br><br>" +
          "Gebruik <strong>GEEN</strong> hulpmiddelen, zoals pen en papier, je mobiel, of je vingers.<br>" +
          "Je mag de nummers wel hardop of in je hoofd herhalen.<br><br>"
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
        "We zullen deze versie van de taak nu eerst 2 keer oefenen.<br><br>" +
        "Druk op een willekeurige knop als je klaar bent om te oefenen.",
      choices: "ALL_KEYS"
    }
  ]
};



var bind_upd_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>"+
    "Je bent nu klaar voor de echte taak.<br><br>" +
    "De taak bestaat uit 6 rondes.<br>" +
    "Vanaf nu krijg je geen feedback meer op je prestaties.<br><br>" +
    "Druk op een willekeurige knop om te beginnen.",
  choices: "ALL_KEYS",
  data: {variable: 'bind_upd_start'},
};


var bind_upd_end = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>"+
      "Dit is het einde van de <strong>geheugentaak</strong>.<br>" +
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


