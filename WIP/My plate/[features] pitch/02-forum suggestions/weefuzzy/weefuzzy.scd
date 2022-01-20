(
fork{
  //Set up some variables
  var meanPitches = FluidDataSet.new(s);//we'll keep our data in here while we process
  var onsetsBuffer = Buffer.new; //this will be our onset positions

  //This function does the main analysis.
  //Putting it up here to try and reduce clutter
  var meanPitchForSlice = {|start,end|
    var pitches = Buffer.new;
    var stats = Buffer.new;
    //we'll use this to filter lower confidence pitches
    var confidences = Buffer.new;

    if(start >= end) {"Invalid indices: %, %".format(start,end).throw}{}; //just in case

    //By using processBlocking here, life is made simpler: everything happens in order
    //on the server command queue
    FluidBufPitch.processBlocking(s,b,start,end - start,features:pitches,unit:1);
    //copy the pitch confidence buffer
    FluidBufSelect.processBlocking(s,pitches,confidences,channels:0);
    //use it as the weights for our stats
    FluidBufStats.processBlocking(s,pitches,numChans:1, stats:stats,weights:confidences);


    //put the stats into a data set, using the start time as a lookup key for later
    meanPitches.setPoint(start,stats);
    meanPitches.size(action:{|s| "Slice %".format(s).postln});
    s.sync; //wait for stuff to finish
    //then tidy up
    pitches.free;
    stats.free;
    confidences.free;
  };

  //Main action: first get the onsets, and wait
  FluidBufOnsetSlice.process(s,b,indices:onsetsBuffer, metric:5,threshold:0.15).wait;

  //Get onsets as array, then iterate over in pairs of [start,end], calling the fn above
  onsetsBuffer.loadToFloatArray(action:{ |a|
    var onsets = Array.newFrom(a) ++ (b.numFrames - 1);
    var slices = onsets.slide(2).clump(2); //rearrange to [start,end]
    "Processing % slices".format(slices.size).postln;
    slices.do{|range|
      meanPitchForSlice.value(range[0],range[1]);
    };
  });

  // We've filled a FluidDataSet with stuff, now dump it as a Dictionary
  meanPitches.dump{|dict|
    //Dictionaries are unordered, and the keys here are Strings.
    //Collect the keys as a sorted array of floats
    var data = dict["data"]; //actual goodies in sub-dictionary called 'data'
    var keys = Array.newFrom(data.keys).collect{|k|k.asFloat}.sort;

    data.postln;
    keys.postln;

    keys.do{|startTime|
      //The mean pitch is the 0th stat, grab it and rounr
      startTime.postln;
      // var meanPitch = data[startTime.asString][0].round;
      // "%: %".format(startTime,meanPitch).postln;
    }
  };
  s.sync;
}
)