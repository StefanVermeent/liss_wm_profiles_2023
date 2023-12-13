// General variables
var fullscreenmode = {
  type: jsPsychFullscreen,
  fullscreen_mode: true,
  message: "<p>De geheugenspelletjes zullen verder gaan in <i>volledig scherm modus</i>.<br>We verzoeken u om in <i>volledig scherm modus</i> te blijven tijdens de gehele duur van de geheugenspelletjes.</p>",
  button_label: "Ga verder"
};

var cursor_off = {
    type: jsPsychCallFunction,
    func: function() {
        document.body.style.cursor= "none";
    }
};

var cursor_on = {
    type: jsPsychCallFunction,
    func: function() {
        document.body.style.cursor= "auto";
    }
};
