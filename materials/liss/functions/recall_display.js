var recall_display = function(stimulus = "?", position, correct){

      // SET LETTERS FOR THE DISPLAY
      var stim1 = (position == 0)? stimulus : "";
      var stim2 = (position == 1)? stimulus : "";
      var stim3 = (position == 2)? stimulus : "";
      var stim4 = (position == 3)? stimulus : "";
      var stim5 = (position == 4)? stimulus : "";
      var stim6 = (position == 5)? stimulus : "";
      var stim7 = (position == 6)? stimulus : "";
      var stim8 = (position == 7)? stimulus : "";
      var stim9 = (position == 8)? stimulus : "";

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
      "<div>" + stim1 + "</div>" +
      "<div>" + stim2 + "</div>" +
      "<div>" + stim3 + "</div>" +
      "<div>" + stim4 + "</div>" +
      "<div>" + stim5 + "</div>" +
      "<div>" + stim6 + "</div>" +
      "<div>" + stim7 + "</div>" +
      "<div>" + stim8 + "</div>" +
      "<div>" + stim9 + "</div>" +
      "</div>" +
      "<br><br>" +
      "<div style = 'margin: auto'><p><strong>Antwoord:</strong></p><span><span><input name='antwoord' type='text' size='4'></span></div><br><br>";

  return html;
};
