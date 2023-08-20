function shuffleWithoutReplacement(arr, size) {
    var shuffled = arr.slice(0), i = arr.length, temp, index;
    while (i--) {
        index = Math.floor((i + 1) * Math.random());
        temp = shuffled[index];
        shuffled[index] = shuffled[i];
        shuffled[i] = temp;
    }
    return shuffled.slice(0, size);
}

function shuffleWithReplacement(arr, size, immediate_reps = false) {

  i = size
  last_bind_pos = arr.slice(-1)

  out_array = []
  previous_pos = null

  if(size == 0) {
    return []
  }

  while (i--) {
    pos = arr[Math.floor(Math.random()*arr.length)];
    if (immediate_reps == false) {
      while (pos == previous_pos) {
        pos = arr[Math.floor(Math.random()*arr.length)];
      }

      if (i == size-1) {
        while (pos == last_bind_pos[0]) {
          pos = arr[Math.floor(Math.random()*arr.length)];
        }
      }


    }
    previous_pos = pos
    out_array.push(pos);
  }
  return out_array
}
