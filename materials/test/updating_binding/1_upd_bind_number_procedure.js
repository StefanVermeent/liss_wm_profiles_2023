// Preload Instruction Images
var preload_bind_upd = {
  type: jsPsychPreload,
  images: [
     'img/instr01.png',
     'img/instr02.png',
     'img/instr03.png',
     'img/instr04.png',
  ]
}


var bind_upd_number_step = -1 // Keep track of where we are in the current trial flow
var bind_upd_number_recall_step = 0 // Keep track of where we are in the recall flow
var number_set = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] // Set of all stimuli
var nCorrectBindUpdNumberRecall = 0
var BindUpdPracticeCorrect = 0


// Empty grid with fixation cross
var fixation = {
   on_start: function(){
    bind_upd_number_step += 1
  },
  stimulus: "+",
  type: jsPsychBindingUpdatingFixation,
  trial_duration: 1000,
  pos: 4,
  nBind: -1,
  nUpd: -1,
  step_number: bind_upd_number_step
};

// Grid with memory item
var bind_upd_number = {
  type: jsPsychBindingUpdatingNumberGrid,
  stimulus: function(){return jsPsych.timelineVariable("stim")[bind_upd_number_step]},
  pos: function(){return jsPsych.timelineVariable("pos")[bind_upd_number_step]},
  nBind: function(){return jsPsych.timelineVariable("nBind")},
  nUpd: function(){return jsPsych.timelineVariable("nUpd")},
  step_number: bind_upd_number_step,
  trial_duration: function(){return 1500},
  data: {
    nBind: function(){return jsPsych.timelineVariable("nBind")},
    nUpd: function(){return jsPsych.timelineVariable("nUpd")},
    task: function(){return jsPsych.timelineVariable("task")}
  }
}

// Empty grid in between memory items
var bind_upd_number_empty = {
  type: jsPsychBindingUpdatingNumberGrid,
  stimulus: "",
  pos: 0,
  nBind: function(){return jsPsych.timelineVariable("nBind")},
  nUpd: function(){return jsPsych.timelineVariable("nUpd")},
  step_number: bind_upd_number_step,
  trial_duration: function(){return 500},
  data: {
    stimulus: function(){return jsPsych.timelineVariable("stim")},
    position: function(){return jsPsych.timelineVariable("pos")},
    nBind: function(){return jsPsych.timelineVariable("nBind")},
    nUpd: function(){return jsPsych.timelineVariable("nUpd")},
    task: function(){return jsPsych.timelineVariable("task")}
  }
}

var bind_upd_number_intertrial = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "Druk op een willekeurige toets op uw toetsenbord om de volgende ronde te starten.",
  choices: "ALL_KEYS",
  data: {
    task: "bind_upd_number_intertrial"
  }
}

var bind_upd_number_break01 = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "U heeft <font color='blue'>6</font> van de <font color='blue'>18</font> rondes voltooid.<br>Als u wilt kunt u even pauzeren voordat u verder gaat.<br><br>Druk op een willekeurige toets op uw toetsenbord om de volgende ronde te starten.",
  choices: "ALL_KEYS",
  data: {
    task: "bind_upd_number_break01"
  }
}

var bind_upd_number_break02 = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "U heeft <font color='blue'>12</font> van de <font color='blue'>18</font> rondes voltooid.<br>Als u wilt kunt u even pauzeren voordat u verder gaat.<br><br>Druk op een willekeurige toets op uw toetsenbord om de volgende ronde te starten.",
  choices: "ALL_KEYS",
  data: {
    task: "bind_upd_number_break02"
  }
}

// Recall of last n letters
var bind_upd_number_recall = {
  type: jsPsychBindingUpdatingNumberRecall,
  recall_position: function(){return jsPsych.timelineVariable("recall_pos")[bind_upd_number_recall_step]},
  nBind: function(){return jsPsych.timelineVariable("nBind")},
  nUpd: function(){return jsPsych.timelineVariable("nUpd")},
  correct_number: function(){return jsPsych.timelineVariable("recall_stim")[bind_upd_number_recall_step]},
  data: {
    variable: 'recall',
    task: function(){return jsPsych.timelineVariable("task")},
    nBind: function(){return jsPsych.timelineVariable("nBind")},
    nUpd: function(){return jsPsych.timelineVariable("nUpd")}
  },
  on_finish: function(){
    nCorrectBindUpdNumberRecall += jsPsych.data.get().last(1).values()[0].accuracy;
  }
};


// ** Looping functions ** //


// Loop over all Binding and Updating stimuli
var bind_upd_number_stim_loop = {
  timeline: [bind_upd_number, bind_upd_number_empty],
  loop_function: function(){
    if(bind_upd_number_step == ((jsPsych.timelineVariable('nBind') + jsPsych.timelineVariable('nUpd')) - 1)){
      bind_upd_number_step = -1
      return false;
    } else {
      bind_upd_number_step += 1
      return true;
    }
  },
}

// Loop over all Recall stimuli
var bind_upd_number_recall_loop = {
  timeline: [bind_upd_number_recall],
  loop_function: function(){
    if(bind_upd_number_recall_step == jsPsych.timelineVariable("nBind")-1){
      bind_upd_number_recall_step = 0
      return false;
    } else {
      bind_upd_number_recall_step += 1
      return true;
    }
  },
}

// The full loop, including fixation, memory items, and recall phase
var bind_upd_number_full_loop01 = {
  timeline: [cursor_off, fixation, bind_upd_number_stim_loop, cursor_on, bind_upd_number_recall_loop, cursor_off].flat(2),
  timeline_variables: [
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_test01"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 0, stimset = number_set, task = "bind_upd_number_test01"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 0, stimset = number_set, task = "bind_upd_number_test01"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 3, stimset = number_set, task = "bind_upd_number_test01"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 4, stimset = number_set, task = "bind_upd_number_test01"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 2, stimset = number_set, task = "bind_upd_number_test01"),
  ],
  randomize_order: true
}

var bind_upd_number_full_loop02 = {
  timeline: [cursor_off, fixation, bind_upd_number_stim_loop, cursor_on, bind_upd_number_recall_loop, cursor_off].flat(2),
  timeline_variables: [
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_test02"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 0, stimset = number_set, task = "bind_upd_number_test02"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 0, stimset = number_set, task = "bind_upd_number_test02"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 4, stimset = number_set, task = "bind_upd_number_test02"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 2, stimset = number_set, task = "bind_upd_number_test02"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 4, stimset = number_set, task = "bind_upd_number_test02"),
  ],
  randomize_order: true
}

var bind_upd_number_full_loop03 = {
  timeline: [cursor_off, fixation, bind_upd_number_stim_loop, cursor_on, bind_upd_number_recall_loop, cursor_off].flat(2),
  timeline_variables: [
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_test03"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 0, stimset = number_set, task = "bind_upd_number_test03"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 0, stimset = number_set, task = "bind_upd_number_test03"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 2, stimset = number_set, task = "bind_upd_number_test03"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 3, stimset = number_set, task = "bind_upd_number_test03"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 3, stimset = number_set, task = "bind_upd_number_test03"),
  ],
  randomize_order: true
}

// Practice feedback

var bind_upd_number_feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {
    var html = "<div style='font-size:20px;'><b>U heeft <font color='blue'>"+ nCorrectBindUpdNumberRecall +" van de " + jsPsych.timelineVariable("nBind") + "</font> nummers goed onthouden.<br><br>";
    return html
  },
  choices: "NO_KEYS",
  trial_duration: 1500,
  data: {
    task: function(){return jsPsych.timelineVariable("task")},
    variable: "full_feedback"
  },
  on_finish: function() {
    BindUpdPracticeCorrect += nCorrectBindUpdNumberRecall
    nCorrectBindUpdNumberRecall = 0
  }
}


// Practice loop
var bind_upd_number_practice_loop = {
  timeline: [cursor_off, fixation, bind_upd_number_stim_loop, cursor_on, bind_upd_number_recall_loop, cursor_off, bind_upd_number_feedback, bind_upd_number_intertrial].flat(2),
  timeline_variables: [
    generate_bind_upd_timeline(nBind = 2, nUpd = 0, stimset = number_set, task = "bind_upd_number_practice"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_practice"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 1, stimset = number_set, task = "bind_upd_number_practice"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 2, stimset = number_set, task = "bind_upd_number_practice"),
  ]
}

var bind_upd_number_practice_repeat = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Wilt u de taak nog eens oefenen?</p>",
  choices: ['Nee, ik ben klaar om verder te gaan', 'Ja, ik wil nogmaals oefenen'],
  prompt: "",
  data: {variable: 'bind_upd_confirmation', task: "bind_upd_number_instructions"}
};

var bind_upd_if_low_accuracy = {
  timeline: [bind_upd_number_practice_repeat],
  conditional_function: function(){

    if(BindUpdPracticeCorrect <= 6){
      return true;
    } else {
      return false;
    }
  }
}

var bind_upd_number_practice_full_repeat_loop = {
  timeline: [bind_upd_number_practice_loop, bind_upd_if_low_accuracy],
  loop_function: function(data){
    if(jsPsych.data.get().last(1).values()[0].response == 1){
      BindUpdPracticeCorrect = 0
      return true;
    } else {
      BindUpdPracticeCorrect = 0
      return false;
    }
  }
};



