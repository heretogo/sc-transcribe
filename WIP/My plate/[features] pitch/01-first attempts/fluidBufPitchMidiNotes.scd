~concatenateBuffers = { |b, c, buf|
  Task({
    t = Main.elapsedTime;
    FluidBufCompose.process(s, source: b,  destination: buf); s.sync;
    FluidBufCompose.process(s, source: c,  destination: buf); s.sync;
    (Main.elapsedTime - t).postln;
  }, SystemClock).play;
};

~path = "/Users/james/Samples/Local/transcribe/Lacy/Evidence.wav"
b = Buffer.readChannel(s, ~path, channels: 0);
c = Buffer.readChannel(s, ~path, channels: 1);
y = Buffer.new(s,numChannels: 1);
~concatenateBuffers.value(b, c, y);

~getMIDInotes = { |in|
  var c = Buffer.new(s);
  Routine{
    t = Main.elapsedTime;
    FluidBufPitch.process(s, in, features: c, unit:1,
      action:{
        c.loadToFloatArray(action: {|x|
          d = x.reshape((x.size()/2).asInteger, 2);
        });
    }).wait;
    (Main.elapsedTime - t).postln;
  }.play
};

~filterMidiArray = { |d|
  e = Array.new;
  d.do({
    arg val, i;
    val.postln;
    if ((val[1] > 0.98)) {e = e.add(val[0].asInteger)};
  });
}

~getMIDInotes.value(y);
d;
~filterMidiArray.value(d);
e;

a = a.size.collect { |n| [ x[n], y[n] ] }.flat;
e;
~main.midi.loadPitches(e);

FluidBufStats;