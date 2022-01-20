b = Buffer.read(s, "/Users/james/Samples/Local/transcribe/Lacy/Evidence.wav");
b.numChannels;

y = Buffer.new(s,numChannels: 1);

~concatenateBuffers = { |path,buf|
  b = Buffer.readChannel(s, path, channels: 0);
  c = Buffer.readChannel(s, path, channels: 1);
  Task({
    t = Main.elapsedTime;
    FluidBufCompose.process(s, source: b,  destination: buf); s.sync;
    FluidBufCompose.process(s, source: c,  destination: buf); s.sync;
    (Main.elapsedTime - t).postln;
  }, SystemClock).play;
};

~concatenateBuffers.value("/Users/james/Samples/Local/transcribe/Lacy/Evidence.wav", y);
y;

~getFrequencies = { |in|
  var c = Buffer.new(s);
  Task({ t = Main.elapsedTime; FluidBufPitch.process(s, in, features: c, action:{c.loadToFloatArray(action: {|x| j = x.reshape((x.size()/2).asInteger, 2)})}).wait; (Main.elapsedTime - t).postln; }, SystemClock).play;
}

~filterArray = { |d|
  e = Array.new;
  d.do({
    arg val, i;
    if ((val[0] > 500) && (val[1] > 0.98)) {e = e.add(i)}; // if pitch is greater than 500Hz and confidence higher than 0.98, keep the index
  });
}

e;

~getFrequencies.value(y);
j;
~filterArray.value(d);
e;
