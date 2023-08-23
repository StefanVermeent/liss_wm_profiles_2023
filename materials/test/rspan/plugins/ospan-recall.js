var jsPsychOspanRecall = (function (jspsych) {
  "use strict";

  const info = {
    name: "ospan-recall",
    parameters: {
      trial_duration: {
        type: jspsych.ParameterType.INT,
        pretty_name: 'Trial duration',
        default: null,
        description: 'How long to show the trial.'
      },
      size_cells: {
        type: jspsych.ParameterType.INT,
        pretty_name: 'size of cells',
        default: 70,
      },
      correct_order: {
        type:jspsych.ParameterType.INT,
        default: undefined,
        description: 'Recored the correct array'
      }
    }
  };

  /**
    * **PLUGIN-NAME**
    *
    * SHORT PLUGIN DESCRIPTION
  *
    * @author YOUR NAME
  * @see {@link https://DOCUMENTATION_URL DOCUMENTATION LINK TEXT}
  */
    class OspanRecallPlugin {
      constructor(jsPsych) {
        this.jsPsych = jsPsych;
      }
      trial(display_element, trial) {

        // making matrix:
        var grid = 3;
        var recalledGrid = [];
        var correctLetters = trial.correct_order
        var display = " "

        var setSize = correctLetters.length
        var leftOver = 12-setSize

        var numbertobutton = {
          "0": "F",
          "1": "H",
          "2": "J",
          "3": "K",
          "4": "L",
          "5": "N",
          "6": "P",
          "7": "Q",
          "8": "R",
          "9": "S",
          "10": "T",
          "11": "V",
        }

        var matrix = [];
        for (var i=0; i<4; i++){
          var m1 = i;
          for (var h=0; h<3; h++){
            var m2 = h;
            matrix.push([m1,m2])
          }
        };

        var paper_size = [(3*(trial.size_cells+30)), ((4*(trial.size_cells+20))+100)];

        var html = '<div id="jspsych-html-button-response-btngroup" style= "position: relative; width:' + paper_size[0] + 'px; height:' + paper_size[1] + 'px"></div>';
        html += '<div style="width: 270"><div class="jspsych-btn-numpad" style="display: inline-block; margin:'+10+' '+2+'" id="jspsych-spatial-span-grid-button-12">?</div>';
        html += '<div class="jspsych-btn-numpad" style="display: inline-block; margin:'+10+' '+2+'" id="jspsych-html-button-response-button-clear">Corrigeer</div>';
        html += '<div class="jspsych-btn-numpad" style="display: inline-block; margin:'+10+' '+40+'" id="jspsych-html-button-response-button">Klaar</div>';
        html += "</div>"

        display_element.innerHTML = html

       // display_element.innerHTML = '<div id="jspsych-html-button-response-btngroup" style= "position: relative; width:' + paper_size[0] + 'px; height:' + paper_size[1] + 'px"></div>';

        var paper = display_element.querySelector("#jspsych-html-button-response-btngroup");

        paper.innerHTML += '<div class="recall-space" style="position: absolute; top:'+ 0 +'px; left:'+(paper_size[0]/2-310)+'px; width:600px; height:64px" id="recall_space">'+ recalledGrid+'</div>';

        var buttons = ["F","H","J","K","L","N","P","Q","R","S","T","V"]

        for (var i = 0; i < matrix.length; i++) {
          var str = buttons[i]

        paper.innerHTML += '<div class="jspsych-operation-span-recall" style="position: absolute; top:'+ (matrix[i][0]*(trial.size_cells+20)+80) +'px; left:'+matrix[i][1]*(trial.size_cells+30)+'px; width:'+(trial.size_cells-6)+'px; height:'+(trial.size_cells-6)+'px"; id="jspsych-spatial-span-grid-button-' + i +'" data-choice="'+i+'">'+str+'</div>';
        }

        // start time
        var start_time = performance.now();

          // Add clicking functionality to buttons
          for (var i = 0; i < matrix.length; i++) {
            paper
            .querySelector("#jspsych-spatial-span-grid-button-" + i)
            .addEventListener("click", (e) => {

              var btn_el = e.currentTarget
              var tt = btn_el.getAttribute('id')
              var recalledN = btn_el.getAttribute("data-choice")
              recalledGrid.push(numbertobutton[recalledN])
              var div = document.getElementById('recall_space');
              display += numbertobutton[recalledN] + " "
              div.innerHTML = display;
            });
          }

          // store response
          var response = {
            rt: null,
            key: null,
          };


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
              recall: recalledGrid,
              stimuli: correctLetters,
              accuracy: response.button
            };

            // move on to the next trial
            this.jsPsych.finishTrial(trial_data);
          }

          // Add clicking functionality to back button
          display_element
            .querySelector("#jspsych-html-button-response-button-clear")
            .addEventListener("click", (e) => {
              recalledGrid = recalledGrid.slice(0, (recalledGrid.length-1))
              var div = document.getElementById('recall_space');
              display = display.slice(0, (display.length-2))
              div.innerHTML = display
            })

          display_element
            .querySelector("#jspsych-spatial-span-grid-button-12")
            .addEventListener("click", (e) => {
              recalledGrid.push("?")
              var div = document.getElementById('recall_space');
              display += "?" + " "
              div.innerHTML = display;
            })

            display_element
              .querySelector("#jspsych-html-button-response-button")
              .addEventListener("click", (e) => {
                var acc=0
                for (var i=0; i<correctLetters.length; i++){
                  if (recalledGrid[i] == correctLetters[i]){
                    acc += 1
                  }
                }
                after_response(acc);
              })
      }
    }
  OspanRecallPlugin.info = info;

  return OspanRecallPlugin;
})(jsPsychModule);
