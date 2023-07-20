var step_number = 0
var possibleLetters = ["F","H","J","K","L","N","P","Q","R","S","T","V"];
var nCorrectRecall = 0
var mathCorrect = false
var nMathCorrect = 0
var ospan_block = 1

// Empty grid with fixation cross
var ospan_fixation = {

  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:60px;">+</div>',
  choices: "NO_KEYS",
  trial_duration: 1500,
  data: {
    task: "ospan_fixation",
    variable: 'fixation',
    step_number: step_number
  }
};

var ospan_fixation_short = {

  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:60px;">+</div>',
  choices: "NO_KEYS",
  trial_duration: 1000,
  data: {
    task: "ospan_fixation",
    variable: 'fixation',
    step_number: step_number
  }
};

var ospan_start_new_trial = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:18px;">' + "Plaats je vingers op de '<strong>A</strong>' en '<strong>L</strong>' toetsen en druk op een willekeurige knop om te beginnen." + '</div>',
  choices: "ALL_KEYS",
  response_ends_trial: true,
  data: {
    task: "ospan_pretrial",
    variable: 'pretrial',
    step_number: step_number
  }
};

var ospan_letter = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){
    return '<div style="font-size:60px;">' + jsPsych.timelineVariable("stim_l")[step_number] + '</div>'
  },
  choices: "No_KEYS",
  trial_duration: 1000,
  data: {
    task: function(){return(jsPsych.timelineVariable("task"))},
    variable: "letter",
    block: ospan_block
  }
}

var ospan_letter_feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {

   // var nCorrectRecall = jsPsych.data.get().last(1).values()[0].accuracy;
    var html = "<div style='font-size:20px;'><b>Je hebt <font color='blue'>"+nCorrectRecall+" van de " + jsPsych.timelineVariable('setSize') + "</font> letters goed onthouden.<br><br></div>";

    return html
  },
  trial_duration: 1500,
  data: {
    task: "ospan",
    variable: "letter_feedback"
  }
}

var ospan_math_feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {

    var html = ''

    if (mathCorrect == true) {
      html += "<div style='font-size:40px;'><font color= '#008000'>GOED</font></div>";
    } else {
      html += "<div style='font-size:40px;'><font color= '#FF0000'>FOUT</font></div>";
    }
    return html
  },
  trial_duration: 1500,
  data: {
    task: "ospan",
    variable: "math_feedback"
  },
  on_finish: function() {
    nMathCorrect = 0
  }
}

var ospan_full_feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {
    var html = "<div style='font-size:20px;'><b>Je hebt <font color='blue'>"+nCorrectRecall+" van de " + jsPsych.timelineVariable('setSize') + "</font> letters goed onthouden.<br><br>";
    html += "Je hebt <font color='blue'>"+nMathCorrect+" van de " + jsPsych.timelineVariable('setSize') + "</font> rekensommen correct opgelost.<br><br></div><br><br><br>";

    return html
  },
  trial_duration: 1500,
  choices: "NO_KEYS",
  data: {
    task: "ospan",
    variable: "full_feedback"
  },
  on_finish: function() {
    nMathCorrect = 0
    nCorrectRecall = 0
  }
}


var ospan_math = {
  type: jsPsychCategorizeHtml,
  stimulus: function(){
    var correct = jsPsych.timelineVariable("math_correct")[step_number]
    var equation = '<div style="font-size:60px;">' + cogloadf(correct = correct)
    return equation
  },
  prompt: "<div style='width:500px; height: 12px;'></div><br><br><br>" +
              "<div style='width: 500px;'><h1 style='float: left; font-size: 20; margin:0;'>A<br>CORRECT</h1><h1 style='float: right; font-size: 20; margin:0;'>L<br>INCORRECT</h1></div>",
  choices: ['a', 'l'],
  key_answer: function(){return jsPsych.timelineVariable("key_answer")[step_number]},
  data: {
    step_number: step_number,
    task: function(){return(jsPsych.timelineVariable("task"))},
    variable: "math",
    block: ospan_block
  },
  trial_duration: 5000,
  correct_text: "",
  incorrect_text: "",
  feedback_duration: 250,
  show_stim_with_feedback: false,
  on_finish: function(data){
    if(jsPsych.pluginAPI.compareKeys(data.response, 'a') & jsPsych.timelineVariable("math_correct") == true) {
      data.correct = true
    }
    if(jsPsych.pluginAPI.compareKeys(data.response, 'a') & jsPsych.timelineVariable("math_correct") == false) {
      data.correct = false
    }
    if(jsPsych.pluginAPI.compareKeys(data.response, 'l') & jsPsych.timelineVariable("math_correct") == false) {
      data.correct = true
    }
    if(jsPsych.pluginAPI.compareKeys(data.response, 'l') & jsPsych.timelineVariable("math_correct") == true) {
      data.correct = false
    }

    mathCorrect = data.correct;
    if (data.correct == true) {
      nMathCorrect += 1
    } else {
      nMathCorrect += 0
    }
  }
}

var ospan_stim_loop = {
  timeline: [ospan_letter, ospan_math],
  loop_function: function(){
    if(step_number == (jsPsych.timelineVariable("setSize")-1)) {
      step_number = 0
      return false;
    } else {
      step_number += 1
      return true;
    }
  }
}
// Loop over all Recall stimuli
var ospan_recall = {
  type: jsPsychOspanRecall,
  correct_order: function() {return jsPsych.timelineVariable('stim_l')},
  data: {
    task: function(){return(jsPsych.timelineVariable("task"))},
    variable: "recall",
    block: ospan_block
  },
  on_finish: function() {
    nCorrectRecall = jsPsych.data.get().last(1).values()[0].accuracy;
  }
}


// The full loop, including fixation, memory items, and recall phase
var ospan_full_loop = {
  on_start: function(){
    ospan_block += 1
  },
  timeline: [ospan_start_new_trial, ospan_fixation, ospan_stim_loop, ospan_recall].flat(2),
  timeline_variables: [
    generate_timeline_variables_ospan(setSize = 2, task = "ospan_test"),
    generate_timeline_variables_ospan(setSize = 3, task = "ospan_test"),
    generate_timeline_variables_ospan(setSize = 4, task = "ospan_test"),
    generate_timeline_variables_ospan(setSize = 5, task = "ospan_test"),
  ],
  repetitions: 3,
  randomize: true
}


// Practice loops

var ospan_practice_letter_loop = {
  timeline: [ospan_fixation_short, ospan_letter],
  loop_function: function(){
    if(step_number == (jsPsych.timelineVariable("setSize")-1)) {
      step_number = 0
      return false;
    } else {
      step_number += 1
      return true;
    }
  }
}

var ospan_practice_letters_full_loop = {
  timeline: [ospan_fixation, ospan_practice_letter_loop, ospan_recall, ospan_letter_feedback].flat(2),
  timeline_variables: [
    generate_timeline_variables_ospan(setSize = 2, task = "ospan_practice"),
    generate_timeline_variables_ospan(setSize = 3, task = "ospan_practice"),
    generate_timeline_variables_ospan(setSize = 4, task = "ospan_practice")
  ]
}

var ospan_practice_math_loop = {
  timeline: [ospan_fixation_short, ospan_math, ospan_math_feedback],
  loop_function: function(){
    if(step_number == (jsPsych.timelineVariable("setSize")-1)) {
      step_number = 0
      return false;
    } else {
      step_number += 1
      return true;
    }
  }
}

var ospan_practice_math_full_loop = {
  timeline: [ospan_fixation, ospan_practice_math_loop].flat(2),
  timeline_variables: [
    generate_timeline_variables_ospan(setSize = 5, task = "ospan_practice"),
  ]
}


var ospan_practice_full_loop = {
  timeline: [ospan_start_new_trial, ospan_fixation, ospan_stim_loop, ospan_recall, ospan_full_feedback].flat(2),
  timeline_variables: [
    generate_timeline_variables_ospan(setSize = 2, task = "ospan_practice"),
    generate_timeline_variables_ospan(setSize = 3, task = "ospan_practice"),
    generate_timeline_variables_ospan(setSize = 4, task = "ospan_practice"),
  ],
}
