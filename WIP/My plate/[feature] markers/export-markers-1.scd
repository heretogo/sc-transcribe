File.use("~/test.txt".standardizePath, "w", { |f| f.write("Doesn't this work?\n is this thing really on ?\n"); });

// { Buffer.loadDialog(s ,action: { |n| buf = n} ) }.defer;

(
fork{
  var buf, slicepoints;
  buf = Buffer.read(s, "/Users/james/Desktop/Computer Music/Markers/Orbits.flac");
  slicepoints = Buffer(s);
  s.sync;

  FluidBufOnsetSlice.process(s,buf,indices:slicepoints,minSliceLength:172.265625).wait;
  { FluidWaveform(buf,slicepoints,Rect(0,0,1600,400)) }.defer;

  slicepoints.loadToFloatArray(action:{
    arg slicepoints_fa,path;
    var h;
    { FileDialog({ |n| path = n; path.postln},
        stripResult: true,
        path: Platform.userAppSupportDir) }.defer;
  h = File("~/test.txt".standardizePath, "w");
  slicepoints_fa.asList.do { |n,i|
    (n / slicepoints.sampleRate).postln;
    h.write( "M%,,%\n".format(i+1, (n / slicepoints.sampleRate)) );
  };
  h.close;
});

};
)

///

h = File("~/test.txt".standardizePath, "w");
h.inspect;
h.write( "zom" );

FloatArray[1.1, 2.2, 3.3, pi, 3.sqrt].asList;
File.use(pathName, mode, function)

f = File("~/test.txt".standardizePath,"w");
f.write("Does this work?\n is this thing on ?\n");
f.close;