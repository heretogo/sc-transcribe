// FluidLoadFolder

(
b = Buffer.read(s, "/Users/james/Samples/Local/transcribe/Lacy/Evidence.wav");
c = Buffer.new(s);
)

// run the process with basic parameters
(
Routine{
    t = Main.elapsedTime;
    FluidBufPitch.process(s, b, features: c).wait;
    (Main.elapsedTime - t).postln;
}.play
)

// look at the analysis
c.plot(separately:true)

// The values are interleaved [pitch,confidence] in the buffer as they are on 2 channels: to get to the right frame, divide the SR of the input by the hopSize, then multiply by 2 because of the channel interleaving
// here we are querying from one frame before (the signal starts at 8192, which is frame 16 (8192/512), therefore starting the query at frame 15, which is index 30.
c.getn(30,10,{|x|x.postln})