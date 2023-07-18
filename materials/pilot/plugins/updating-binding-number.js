var jsPsychBindingUpdatingNumberGrid = (function (jspsych) {
  "use strict";

  const info = {
    name: 'binding-updating-number-grid',
    parameters: {
      stimulus: {
        type: jspsych.ParameterType.HTML_STRING,
        default: null,
        description: 'The HTML string to be displayed'
      },
      pos: {
        type: jspsych.ParameterType.INT,
        default: undefined,
        description: "Position in the grid where the stimulus will be presented",
      },
      nBind: {
        type: jspsych.ParameterType.INT,
        default: undefined,
        description: "Number of bindings steps",
      },
      nUpd: {
        type: jspsych.ParameterType.INT,
        default: undefined,
        description: "Number of updating steps",
      },
      step_number: {
        type: jspsych.ParameterType.INT,
        default: undefined,
        description: "Keeps track of the current step in the trial"
      },
      choices: {
        type: jspsych.ParameterType.KEYCODE,
        array: true,
        default: "NO_KEYS",
        description: 'The keys the subject is allowed to press to respond to the stimulus.'
      },
      trial_duration: {
        type: jspsych.ParameterType.INT,
        default: 1000,
        description: 'How long to show the trial.'
      },
      response_ends_trial: {
        type: jspsych.ParameterType.BOOL,
        default: false,
        description: 'If true, trial will end when subject makes a response.'
      },
    }
  };

  /**
   * **UpdatingBindingGrid**
   *
   * Implements the updating and binding working memory task used in Wilhelm et al., 2013.
   *
   * @author Stefan Vermeent
   * @see {@link https://github.com/stefanvermeent/liss_wm_profiles_2023 Github link}
   */

    class BindingUpdatingNumberGridPlugin {
      constructor(jsPsych) {
        this.jsPsych = jsPsych;
      }
      trial(display_element, trial) {

        // ** CURRENT STIMULUS TO PRESENT
      var current_letter = trial.stimulus

      // SET LETTERS FOR THE DISPLAY
      var letter1 = (trial.pos == 0)? current_letter : "";
      var letter2 = (trial.pos == 1)? current_letter : "";
      var letter3 = (trial.pos == 2)? current_letter : "";
      var letter4 = (trial.pos == 3)? current_letter : "";
      var letter5 = (trial.pos == 4)? current_letter : "";
      var letter6 = (trial.pos == 5)? current_letter : "";
      var letter7 = (trial.pos == 6)? current_letter : "";
      var letter8 = (trial.pos == 7)? current_letter : "";
      var letter9 = (trial.pos == 8)? current_letter : "";

      // Construct and display 3 X 3 grid
      var html = "<style>" +
        ".grid-container {" +
          "display: inline-grid;" +
          "grid-template-columns: auto auto auto;" +
          "grid-template-rows: auto auto auto;" +
          "grid-gap: 0px;" +
        "}" +

        ".grid-container > div {" +
          "display: flex;" +
          "justify-content: center;" +
          "align-items: center;" +
          "background-color: solid black;" +
          "border: 1px solid black;" +
          "font-size: 70px;" +
          "font-family: sans-serif;" +
          "height: 90px;" +
          "width: 90px;" +
        "}" +
        "</style>" +

      "<div class='grid-container'>" +
      "<div>" + letter1 + "</div>" +
      "<div>" + letter2 + "</div>" +
      "<div>" + letter3 + "</div>" +
      "<div>" + letter4 + "</div>" +
      "<div>" + letter5 + "</div>" +
      "<div>" + letter6 + "</div>" +
      "<div>" + letter7 + "</div>" +
      "<div>" + letter8 + "</div>" +
      "<div>" + letter9 + "</div>" +
      "</div>"

      // draw
      display_element.innerHTML = html;

      var response = {
        rt: null,
        key: null
      };

      const end_trial = () => {
      // kill any remaining setTimeout handlers
      this.jsPsych.pluginAPI.clearAllTimeouts();

      // kill keyboard listeners
      if (typeof keyboardListener !== "undefined") {
        this.jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
      }

        var step_type = (trial.step_number > trial.nBind)? "updating" : "binding";

        // gather the data to store for the trial
        var trial_data = {
          rt: response.rt,
          stimulus: trial.stimulus,
          response: response.key,
          step_type: step_type
        };

        // clear the display
        display_element.innerHTML = '';

        // end trial
        this.jsPsych.finishTrial(trial_data);
      }

      if (trial.trial_duration !== null) {
        this.jsPsych.pluginAPI.setTimeout(end_trial, trial.trial_duration);
      }
    }
  }

  BindingUpdatingNumberGridPlugin.info = info;

  return BindingUpdatingNumberGridPlugin;
})(jsPsychModule);
