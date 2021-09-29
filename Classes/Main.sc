Transcription {
  var s, <>a, <>o, <>reaper, <>out, deviceName, portName;

  *new { |s|
    ^super.newCopyArgs(
      s ? Server.default
    ).init;
  }

  init {
    s.waitForBoot {
      "Initialize Main NewClass".postln;
      Task {
        reaper = NetAddr("127.0.0.1", 8000); s.sync;
        "loading controllers".postln;
        out = MIDIOut.newByName(deviceName ? "IAC Driver", portName ? "Bus 1", false);
        this.loadSynthDefs; s.sync;
        this.registerOSCFuncs; s.sync;
      }.play(AppClock);
    }
  }

  loadSynthDefs {
    "Loading SynthDefs".postln;

    (
      SynthDef(\pitchfollower, { |out, vol=1.0, buf|
        var freq, hasFreq, in, sound, sum;
        in = PlayBuf.ar(numChannels: 2, bufnum: buf, rate: BufRateScale.kr(buf), trigger: 1, startPos: 0, loop: 1);
        sum = Mix.new(in);
        # freq, hasFreq = Tartini.kr(in);
        SendReply.kr(trig: Changed.kr(freq), cmdName: '/transcribe', values: freq);
      }).add
    );

    SynthDef(\pitchfollowerBuffer, { |out, vol=1.0, buf, rate=60|
      var chain, onset, freq, hasFreq, in, trig;
      in = PlayBuf.ar(numChannels: 2, bufnum: buf, rate: 1, trigger: 1, startPos: 0, loop: 0, doneAction: 2);
      chain = FFT({ LocalBuf(2048) } ! 2, in);
      onset = Onsets.kr(chain, odftype: 'rcomplex');
      trig = Impulse.kr(rate, mul: EnvGen.kr(Env.linen(sustainTime: 0.15, releaseTime: 0.15), onset));
      # freq, hasFreq = Tartini.kr(in);
      SendReply.kr(trig: trig, cmdName: '/transcribe', values: freq.cpsmidi);
      Out.ar(0, in);
    }).add;

    //try FluidPitch
  }

  registerOSCFuncs {
    "registerOSCFuncs SendReply".postln;
    o = nil;
    o = o.add(OSCdef(\transcribe, {|msg|
      var pitch = msg[3];
      pitch.postln;
      Task({
        pitch.postln; out.noteOn(0, pitch, 64); 0.05.wait; out.noteOff(0, pitch, 64);
      }, AppClock).play;
    }, '/transcribe'));
    // REAPER Transport
    o = o.add(OSCFunc({|n| n.postln; }, \record));
    o = o.add(OSCFunc({|n| n.postln; }, \stop));
    o = o.add(OSCFunc({|n| n.postln; }, \play));
    o = o.add(OSCFunc({|n| n.postln; }, \pause));
  }

}