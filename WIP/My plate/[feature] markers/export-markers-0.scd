(
s.waitForBoot{

	fork{
    var buf = Buffer.read(s, "/Volumes/db/music/00-instruments/Strings/Viola/Mat Maneri/Other/Mat Maneri & Randy Peterson – Light Trigger/04 Orbits.flac");
		var slicepoints = Buffer(s);

		s.sync;

    FluidBufOnsetSlice.process(s,buf,indices:slicepoints,minSliceLength:172.265625).wait;
    { FluidWaveform(buf,slicepoints,Rect(0,0,1600,400)) }.defer;

		slicepoints.loadToFloatArray(action:{
			arg slicepoints_fa;
			slicepoints_fa.asList.doAdjacentPairs{
				arg startPos, endPos;
        var playbuf = {
					var dur_secs = (endPos - startPos) / BufSampleRate.ir(buf);
					var env = EnvGen.kr(Env([0,1,1,0],[0.03,dur_secs-0.06,0.03]),doneAction:2);
					var sig = PlayBuf.ar(1,buf,BufRateScale.ir(buf),startPos:startPos);
					sig.dup * env;
				};
        playbuf.play; 5.wait;
        playbuf.play; 7.wait;
			};
		});

	};
}
)