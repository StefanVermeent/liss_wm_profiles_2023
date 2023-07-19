
var bind_upd_number_step = -1 // Keep track of where we are in the current trial flow
var bind_upd_number_recall_step = 0 // Keep track of where we are in the recall flow
var number_set = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] // Set of all stimuli

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

// Recall of last n letters
var bind_upd_number_recall = {
  type: jsPsychBindingUpdatingNumberRecall,
  recall_position: function(){return jsPsych.timelineVariable("recall_pos")[bind_upd_number_recall_step]},
  nBind: function(){return jsPsych.timelineVariable("nBind")},
  nUpd: function(){return jsPsych.timelineVariable("nUpd")},
  correct_number: function(){return jsPsych.timelineVariable("recall_stim")[bind_upd_number_recall_step]},
  data: {
    variable: 'recall',
    task: function(){return jsPsych.timelineVariable("task")}
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
  }
}

// The full loop, including fixation, memory items, and recall phase
var bind_upd_number_full_loop = {
  timeline: [fixation, bind_upd_number_stim_loop, bind_upd_number_recall_loop].flat(2),
  timeline_variables: [
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 0, stimset = number_set, task = "bind_upd_number_test"),

    generate_bind_upd_timeline(nBind = 3, nUpd = 2, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 3, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 4, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 5, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 2, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 3, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 4, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 5, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 2, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 3, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 4, stimset = number_set, task = "bind_upd_number_test"),
    generate_bind_upd_timeline(nBind = 5, nUpd = 5, stimset = number_set, task = "bind_upd_number_test"),

  ]
}


// Practice loop
var bind_upd_number_practice_loop = {
  timeline: [fixation, bind_upd_number_stim_loop, bind_upd_number_recall_loop].flat(2),
  timeline_variables: [
    generate_bind_upd_timeline(nBind = 2, nUpd = 0, stimset = number_set, task = "bind_upd_number_practice"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 0, stimset = number_set, task = "bind_upd_number_practice"),
    generate_bind_upd_timeline(nBind = 3, nUpd = 1, stimset = number_set, task = "bind_upd_number_practice"),
    generate_bind_upd_timeline(nBind = 4, nUpd = 2, stimset = number_set, task = "bind_upd_number_practice"),
  ]
}




