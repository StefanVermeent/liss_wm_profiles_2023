var step_number = 0
var possibleLetters = ["F","H","J","K","L","N","P","Q","R","S","T","V"];


// Empty grid with fixation cross
var ospan_fixation = {

  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:60px;">+</div>',
  choices: "NO_KEYS",
  trial_duration: 1500,
  data: {
    variable: 'fixation',
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
  on_finish: function(){
    console.log('blabla')
  }

}

var ospan_math = {
  type: jsPsychCategorizeHtml,
  stimulus: function(){
    console.log(step_number)
    var correct = jsPsych.timelineVariable("math_correct")[step_number]
    var equation = '<div style="font-size:60px;">' + cogloadf(correct = correct)
    console.log(correct)
    return equation
  },
  prompt: "<div style='width:500px; height: 12px;'></div><br><br><br>" +
              "<div style='width: 500px;'><h1 style='float: left; font-size: 20; margin:0;'>A<br>CORRECT</h1><h1 style='float: right; font-size: 20; margin:0;'>L<br>INCORRECT</h1></div>",
  choices: ['a', 'l'],
  key_answer: function(){return jsPsych.timelineVariable("key_answer")[step_number]},
  data: {
    step_number: step_number
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
  correct_order: function() {return jsPsych.timelineVariable('stim_l')}
}


// The full loop, including fixation, memory items, and recall phase
var ospan_full_loop = {
  timeline: [ospan_fixation, ospan_stim_loop, ospan_recall].flat(2),
  timeline_variables: [
    generate_timeline_variables_ospan(setSize = 3),
    generate_timeline_variables_ospan(setSize = 4),
    generate_timeline_variables_ospan(setSize = 5),
  ],
  repetitions: 2
}


