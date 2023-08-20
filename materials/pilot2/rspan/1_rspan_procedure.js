var preload_rspan_arr = {
  type: jsPsychPreload,
  images: [
     'rspan/img/a1_short.png',
     'rspan/img/a2_short.png',
     'rspan/img/a3_short.png',
     'rspan/img/a4_short.png',
     'rspan/img/a5_short.png',
     'rspan/img/a6_short.png',
     'rspan/img/a7_short.png',
     'rspan/img/a8_short.png',
  ]
}

var preload_g = {
  type: jsPsychPreload,
  images: [
     'rspan/img/g_0_normal.png',
     'rspan/img/g_45_normal.png',
     'rspan/img/g_90_normal.png',
     'rspan/img/g_135_normal.png',
     'rspan/img/g_180_normal.png',
     'rspan/img/g_225_normal.png',
     'rspan/img/g_270_normal.png',
     'rspan/img/g_315_normal.png',
     'rspan/img/g_0_mirror.png',
     'rspan/img/g_45_mirror.png',
     'rspan/img/g_90_mirror.png',
     'rspan/img/g_135_mirror.png',
     'rspan/img/g_180_mirror.png',
     'rspan/img/g_225_mirror.png',
     'rspan/img/g_270_mirror.png',
     'rspan/img/g_315_mirror.png',
  ]
}

var a1_short    = "<img src='rspan/img/a1_short.png' height=300>";
var a2_short    = "<img src='rspan/img/a2_short.png' height=300>";
var a3_short    = "<img src='rspan/img/a3_short.png' height=300>";
var a4_short    = "<img src='rspan/img/a4_short.png' height=300>";
var a5_short    = "<img src='rspan/img/a5_short.png' height=300>";
var a6_short    = "<img src='rspan/img/a6_short.png' height=300>";
var a7_short    = "<img src='rspan/img/a7_short.png' height=300>";
var a8_short    = "<img src='rspan/img/a8_short.png' height=300>";

var g0_normal   = "<img src='rspan/img/g_0_normal.png'>";
var g45_normal  = "<img src='rspan/img/g_45_normal.png'>";
var g90_normal  = "<img src='rspan/img/g_90_normal.png'>";
var g135_normal = "<img src='rspan/img/g_135_normal.png'>";
var g180_normal = "<img src='rspan/img/g_180_normal.png'>";
var g225_normal = "<img src='rspan/img/g_225_normal.png'>";
var g270_normal = "<img src='rspan/img/g_270_normal.png'>";
var g315_normal = "<img src='rspan/img/g_315_normal.png'>";
var g0_mirror   = "<img src='rspan/img/g_0_mirror.png'>";
var g45_mirror  = "<img src='rspan/img/g_45_mirror.png'>";
var g90_mirror  = "<img src='rspan/img/g_90_mirror.png'>";
var g135_mirror = "<img src='rspan/img/g_135_mirror.png'>";
var g180_mirror = "<img src='rspan/img/g_180_mirror.png'>";
var g225_mirror = "<img src='rspan/img/g_225_mirror.png'>";
var g270_mirror = "<img src='rspan/img/g_270_mirror.png'>";
var g315_mirror = "<img src='rspan/img/g_315_mirror.png'>";


var step_number = 0
var arrowSet  = [a1_short, a2_short, a3_short, a4_short, a5_short, a6_short, a7_short, a8_short];
var normalSet = [g0_normal, g45_normal, g90_normal, g135_normal, g180_normal, g225_normal, g270_normal, g315_normal]
var mirrorSet = [g0_mirror, g45_mirror, g90_mirror, g135_mirror, g180_mirror, g225_mirror, g270_mirror, g315_mirror]
var nCorrectRspanRecall = 0
var RotationCorrect = false
var nRotationCorrect = 0
var rspan_block = 1

// Empty grid with fixation cross
var rspan_fixation = {

  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:60px;">+</div>',
  choices: "NO_KEYS",
  trial_duration: 1500,
  data: {
    task: "rspan_fixation",
    variable: 'fixation',
    step_number: step_number
  }
};

var rspan_fixation_short = {

  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:60px;">+</div>',
  choices: "NO_KEYS",
  trial_duration: 1000,
  data: {
    task: "rspan_fixation",
    variable: 'fixation',
    step_number: step_number
  }
};

var rspan_start_new_trial = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:18px;">' + "Plaats je vingers op de '<strong>A</strong>' en '<strong>L</strong>' toetsen op je toetsenbord en druk op een willekeurige toets om te beginnen." + '</div>',
  choices: "ALL_KEYS",
  response_ends_trial: true,
  data: {
    task: "rspan_pretrial",
    variable: 'pretrial',
    step_number: step_number
  }
};

var rspan_arrow = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){
    return '<div>' + jsPsych.timelineVariable("stim_arr")[step_number] + '</div>'
  },
  choices: "No_KEYS",
  trial_duration: 1000,
  data: {
    task: function(){return(jsPsych.timelineVariable("task"))},
    variable: "letter",
    block: rspan_block
  }
}

var rspan_arrow_feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {
    var html = "<div style='font-size:20px;'><b>Je hebt <font color='blue'>"+nCorrectRspanRecall+" van de " + jsPsych.timelineVariable('setSize') + "</font> pijlen goed onthouden.<br><br></div>";

    return html
  },
  trial_duration: 1500,
  data: {
    task: "rspan",
    variable: "arrow_feedback"
  }
}

var rspan_rotation_feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {
    var html = ''

    if (RotationCorrect == true) {
      html += "<div style='font-size:40px;'><font color= '#008000'>GOED</font></div>";
    } else {
      html += "<div style='font-size:40px;'><font color= '#FF0000'>FOUT</font></div>";
    }
    return html
  },
  trial_duration: 1500,
  data: {
    task: "rspan",
    variable: "rotation_feedback"
  },
  on_finish: function() {
    nRotationCorrect = 0
  }
}

var rspan_full_feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function() {
    var html = "<div style='font-size:20px;'><b>Je hebt <font color='blue'>"+nCorrectRspanRecall+" van de " + jsPsych.timelineVariable('setSize') + "</font> pijlen goed onthouden.<br><br>";
    html += "Je hebt <font color='blue'>"+nRotationCorrect+" van de " + jsPsych.timelineVariable('setSize') + "</font> letters goed beantwoord.<br><br></div><br><br><br>";

    return html
  },
  trial_duration: 1500,
  choices: "NO_KEYS",
  data: {
    task: "rspan",
    variable: "full_feedback"
  },
  on_finish: function() {
    nRotationCorrect = 0
    nCorrectRspanRecall = 0
  }
}


var rspan_rotation = {
  type: jsPsychCategorizeHtml,
  stimulus: function(){
    return '<div">' + jsPsych.timelineVariable("stim_rot")[step_number] + '</div>'
  },
  prompt: "<div style='width:500px; height: 12px;'></div><br>" +
              "<div style='width: 500px;'><h1 style='float: left; font-size: 20; margin:0;'>'A': <font color='#008000'>  NORMAAL</font></h1><h1 style='float: right; font-size: 20; margin:0;'>'L': <font color='#FF0000'>  GESPIEGELD</font></h1></div>",
  choices: ['a', 'l'],
  key_answer: function(){return jsPsych.timelineVariable("key_answer")[step_number]},
  data: {
    step_number: step_number,
    task: function(){return(jsPsych.timelineVariable("task"))},
    variable: "rotation",
    block: rspan_block
  },
  trial_duration: 5000,
  correct_text: "",
  incorrect_text: "",
  feedback_duration: 0,
  show_stim_with_feedback: false,
  on_finish: function(data){
    if(jsPsych.pluginAPI.compareKeys(data.response, 'a') & jsPsych.timelineVariable("rot_correct") == true) {
      data.correct = true
    }
    if(jsPsych.pluginAPI.compareKeys(data.response, 'a') & jsPsych.timelineVariable("rot_correct") == false) {
      data.correct = false
    }
    if(jsPsych.pluginAPI.compareKeys(data.response, 'l') & jsPsych.timelineVariable("rot_correct") == false) {
      data.correct = true
    }
    if(jsPsych.pluginAPI.compareKeys(data.response, 'l') & jsPsych.timelineVariable("rot_correct") == true) {
      data.correct = false
    }

    RotationCorrect = data.correct;
    if (data.correct == true) {
      nRotationCorrect += 1
    } else {
      nRotationCorrect += 0
    }
  }
}

var rspan_stim_loop = {
  timeline: [rspan_arrow, rspan_rotation],
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
var rspan_recall = {
  type: jsPsychRspanRecall,
  correct_order: function() {return jsPsych.timelineVariable('stim_arr')},
  data: {
    task: function(){return jsPsych.timelineVariable("task")},
    variable: "recall",
    block: rspan_block,
    set_size: function(){return jsPsych.timelineVariable("setSize")}
  },
  on_finish: function() {
    nCorrectRspanRecall = jsPsych.data.get().last(1).values()[0].accuracy;
  }
}


// The full loop, including fixation, memory items, and recall phase
var rspan_full_loop = {
  on_start: function(){
    rspan_block += 1
  },
  timeline: [cursor_off, rspan_start_new_trial, rspan_fixation, rspan_stim_loop, cursor_on, rspan_recall, cursor_off].flat(2),
  timeline_variables: [
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 4, task = "rspan_test"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 4, task = "rspan_test"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 4, task = "rspan_test"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 5, task = "rspan_test"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 5, task = "rspan_test"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 5, task = "rspan_test"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 6, task = "rspan_test"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 6, task = "rspan_test"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 6, task = "rspan_test"),
  ],
  randomize_order: true
}

// Practice loops

var rspan_practice_arrows_loop = {
  timeline: [rspan_fixation_short, rspan_arrow],
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

var rspan_practice_arrows_full_loop = {
  timeline: [cursor_off, rspan_fixation, rspan_practice_arrows_loop, cursor_on, rspan_recall, cursor_off, rspan_arrow_feedback].flat(2),
  timeline_variables: [
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 2, task = "rspan_practice"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 3, task = "rspan_practice"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 4, task = "rspan_practice")
  ]
}

var rspan_practice_rotation_loop = {
  timeline: [rspan_fixation_short, rspan_rotation, rspan_rotation_feedback],
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

var rspan_practice_rotation_full_loop = {
  timeline: [cursor_off, rspan_fixation, rspan_practice_rotation_loop].flat(2),
  timeline_variables: [
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 5, task = "rspan_practice"),
  ]
}


var rspan_practice_full_loop = {
  timeline: [cursor_off, rspan_start_new_trial, rspan_fixation, rspan_stim_loop, cursor_on, rspan_recall, cursor_off, rspan_full_feedback].flat(2),
  timeline_variables: [
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 2, task = "rspan_practice"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 3, task = "rspan_practice"),
    generate_timeline_variables_rspan(stimset = arrowSet, normalSet = normalSet, mirrorSet = mirrorSet, setSize = 4, task = "rspan_practice"),
  ],
}
