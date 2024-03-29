var jsPsychBindingUpdatingColorRecall = (function (jspsych) {
  "use strict";

  const info = {
    name: 'binding-updating-color-recall',
    parameters: {
      stimulus: {
        type: jspsych.ParameterType.HTML_STRING,
        default: "?",
        description: 'The HTML string to be displayed',
      },
      recall_position: {
        type: jspsych.ParameterType.INT,
        default: undefined,
        description: "Position in the grid where the stimulus will be presented",
      },
      preamble: {
        type: jspsych.ParameterType.HTML_STRING,
        default: "Welke letter werd als laatst getoond op de plaats van het vraagteken?"
      },
      correct_color: {
        type: jspsych.ParameterType.INT,
        default: undefined
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
      trial_duration: {
        type: jspsych.ParameterType.INT,
        default: null
      },
      response_ends_trial: {
        type: jspsych.ParameterType.BOOL,
        default: true,
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

    class BindingUpdatingColorRecallPlugin {
      constructor(jsPsych) {
        this.jsPsych = jsPsych;
      }
      trial(display_element, trial) {

        // ** CURRENT STIMULUS TO PRESENT
      var current_stim = trial.stimulus;

      // SET LETTERS FOR THE DISPLAY
      var stim1 = (trial.recall_position == 0)? current_stim : "";
      var stim2 = (trial.recall_position == 1)? current_stim : "";
      var stim3 = (trial.recall_position == 2)? current_stim : "";
      var stim4 = (trial.recall_position == 3)? current_stim : "";
      var stim5 = (trial.recall_position == 4)? current_stim : "";
      var stim6 = (trial.recall_position == 5)? current_stim : "";
      var stim7 = (trial.recall_position == 6)? current_stim : "";
      var stim8 = (trial.recall_position == 7)? current_stim : "";
      var stim9 = (trial.recall_position == 8)? current_stim : "";

      var recalledNumber = []

      // Construct and display 3 X 3 grid
      var html = "<style>" +
        ".grid-container {" +
          "display: inline-grid;" +
          "grid-template-columns: auto auto auto;" +
          "grid-template-rows: auto auto auto;" +
          "grid-gap: 0px;" +
        "}" +

        ".grid-response-container {" +
          "display: inline-grid;" +
          "grid-template-columns: auto auto auto auto auto auto auto auto;" +

          "grid-gap: 5px;" +
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

        ".grid-response-container > div {" +
          "display: flex;" +
          "justify-content: center;" +
          "align-items: center;" +
          "margin: 40px 5px;" +
          "background-color: solid black;" +
          "cursor: pointer;" +
          "border: 1px solid black;" +
          "font-size: 20px;" +
          "font-family: sans-serif;" +
          "height: 30px;" +
          "width: 30px;" +
        "}" +
        "</style>" +

        "<div style='width: 470px; height: 500px'>" +

      "<br><br><br><br><div class='grid-container' id='stim-display'>" +
      "<div>" + stim1 + "</div>" +
      "<div>" + stim2 + "</div>" +
      "<div>" + stim3 + "</div>" +
      "<div>" + stim4 + "</div>" +
      "<div>" + "+" + "</div>" +
      "<div>" + stim6 + "</div>" +
      "<div>" + stim7 + "</div>" +
      "<div>" + stim8 + "</div>" +
      "<div>" + stim9 + "</div>" +
      "</div>"



      html += "<div class='grid-response-container' id='response-display'>" +
      "<div id='jspsych-response-grid-button-0' style = 'background-color:" + "#117733" + "' data-choice='#117733'></div>" +
      "<div id='jspsych-response-grid-button-1' style = 'background-color:" + '#DDCC77' + "' data-choice='#DDCC77'></div>" +
      "<div id='jspsych-response-grid-button-2' style = 'background-color:" + '#661100' + "' data-choice='#661100'></div>" +
      "<div id='jspsych-response-grid-button-3' style = 'background-color:" + '#F357D9' + "' data-choice='#F357D9'></div>" +
      "<div id='jspsych-response-grid-button-4' style = 'background-color:" + '#88CCEE' + "' data-choice='#88CCEE'></div>" +
      "<div id='jspsych-response-grid-button-5' style = 'background-color:" + '#332288' + "' data-choice='#332288'></div>" +
      "<div id='jspsych-response-grid-button-6' style = 'background-color:" + '#888888' + "' data-choice='#888888'></div>" +
      "<div id='jspsych-response-grid-button-7' style = 'background-color:" + '#000000' + "' data-choice='#000000'></div>" +
      "</div>"

       html += '<div class="jspsych-btn-numpad" style="display: inline-block; margin:'+10+' '+2+'; position: relative;" id="jspsych-html-button-response-button">Klaar</div>' +
       "</div>"

      display_element.innerHTML = html

      // store response
          var response = {
            rt: null,
            key: null,
          };

           var start_time = performance.now();


          function after_response(choice) {

            // measure rt
            var end_time = performance.now();
            var rt = end_time - start_time;
            var choiceRecord = choice;
            response.button = choice;
            response.rt = rt;

            // disable all the buttons after a response
            var btns = document.querySelectorAll(".jspsych-html-button-response-button button");
            for (var i = 0; i < btns.length; i++) {
              btns[i].setAttribute("disabled", "disabled");
            }
            clear_display();
            end_trial();
          };

          if (trial.trial_duration !== null) {
            this.jsPsych.pluginAPI.setTimeout(function() {
              clear_display();
              end_trial();
            }, trial.trial_duration);
          }


          function clear_display(){
            display_element.innerHTML = '';
          }

          const end_trial = () => {

            // kill any remaining setTimeout handlers
            this.jsPsych.pluginAPI.clearAllTimeouts();

            // gather the data to store for the trial
            var trial_data = {
              rt: response.rt,
              recall: recalledNumber,
              stimuli: trial.correct_color,
              accuracy: response.button
            };

            // move on to the next trial
            this.jsPsych.finishTrial(trial_data);
          }

          display_element
              .querySelector("#jspsych-html-button-response-button")
              .addEventListener("click", (e) => {
                var acc=0
                if (recalledNumber == trial.correct_color){
                  acc += 1
                }
                after_response(acc);
              })

          for (var i = 0; i < 8; i++) {
            display_element
              .querySelector("#jspsych-response-grid-button-" + i)
              .addEventListener("click", (e) => {

                recalledNumber = []

                for (var i = 0; i < 8; i++) {
                  display_element.querySelector("#jspsych-response-grid-button-" + i).style.borderWidth = 1
                }
                var btn_el = e.currentTarget
               // btn_el.style.backgroundColor =
                btn_el.style.borderWidth = 3;

                recalledNumber = btn_el.getAttribute("data-choice")
                console.log(recalledNumber)
              })
          }


    }
  }

  BindingUpdatingColorRecallPlugin.info = info;

  return BindingUpdatingColorRecallPlugin;
})(jsPsychModule);
