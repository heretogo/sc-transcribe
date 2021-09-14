a = Transcription.new(s: Server.default);

// Transcribe
(
a.reaper.sendMsg("/record");
t = Buffer.read(s, "/Users/james/Samples/Local/transcribe/Lacy/Evidence.wav");
i = Synth.new(\pitchfollowerBuffer, [buf: t, rate: 5]);
i.onFree({ a.reaper.sendMsg("/stop") });
)

i.free;

// TODO: set instrument range bounds to discard useless stuff
// TODO: create a function which separates the melody voice from the drums