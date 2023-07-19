function shuffle_identical(arr1, arr2) {
  var index = arr1.length;
  var rnd, tmp1, tmp2;

  while (index) {
    rnd = Math.floor(Math.random() * index);
    index -= 1;
    tmp1 = arr1[index];
    tmp2 = arr2[index];
    arr1[index] = arr1[rnd];
    arr2[index] = arr2[rnd];
    arr1[rnd] = tmp1;
    arr2[rnd] = tmp2;
  }
}


var generate_bind_upd_timeline = function(nBind, nUpd, stimset, task){

  var bindStims = shuffleWithoutReplacement(arr = stimset, size = nBind)
  var updStims = shuffleWithReplacement(arr = stimset.filter(x => !bindStims.includes(x)), size = nUpd, immediate_reps = false)
  var stims = bindStims.concat(updStims)

  //var stims = shuffleWithoutReplacement(arr = stimset, size = nBind+nUpd)
  var bindPos = shuffleWithoutReplacement(arr = [0,1,2,3, 5,6,7,8], size = nBind)
  var updPos = shuffleWithReplacement(arr = bindPos, size = nUpd, immediate_reps = false)
  var allPos = bindPos.concat(updPos)


  var recallStims = []
  var recallPos = []

  var recall_i = allPos.length -1

  while (recallPos.length < nBind) {

    if (recallPos.includes(allPos[recall_i])) {
      recall_i -= 1
    } else {
      recallPos.push(allPos[recall_i])
      recallStims.push(stims[recall_i])
      recall_i -= 1
    }

  }


  // Randomize recall order and make sure stimuli and their positions are still matched across arrays

  shuffle_identical(recallStims, recallPos)

  return({stim: stims, pos: allPos, nBind: nBind, nUpd: nUpd, recall_pos: recallPos, recall_stim: recallStims, task: task})
}


generate_timeline_variables_ospan = function(setSize){
  var stims = shuffleWithoutReplacement(arr = ["F","H","J","K","L","N","P","Q","R","S","T","V"], size = setSize);
  var math_correct = shuffleWithReplacement(arr = [true, false], size = setSize, immediate_reps = true)

  var answer_i = []
  for (var i = 0; i < setSize; i++) {
    if(math_correct[i] == true) {
      answer_i.push('a')
    } else {
      answer_i.push('l')
    }
  }
  return({stim_l: stims, math_correct: math_correct, key_answer: answer_i, setSize: setSize})
}
