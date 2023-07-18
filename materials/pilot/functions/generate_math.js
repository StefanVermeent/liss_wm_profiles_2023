var cogloadf = function(correct){  // generates math questions



  var possibleOperations = [" + ", " - "];
  operation = jsPsych.randomization.sampleWithReplacement(possibleOperations, 1)[0];
  if (operation==" + "){
    num1 = Math.floor(jStat.uniform.sample(1, 10));
    num2 =  Math.floor(jStat.uniform.sample(1, 10));
    ans = num1 + num2;
  } else if (operation==" - "){
    num1 = Math.floor(jStat.uniform.sample(1, 10));
    num2 = Math.floor(jStat.uniform.sample(1, (num1-1)));
    ans = num1 - num2;
  }

  if (!correct){   // generates incorrect answers
    ansDiff = jsPsych.randomization.sampleWithReplacement([1,2],1)[0];
    coinFlip = jsPsych.randomization.sampleWithReplacement([true, false],1)[0];
    if (coinFlip){
      ans += ansDiff;
    } else {
      ans -= ansDiff;
    }
    if (ans<0){
      ans += 2*ansDiff; //ensuring no negative incorrect answers
    }
  }

  var equation = num1+operation+num2+' = '+ans;

  return equation;
};
