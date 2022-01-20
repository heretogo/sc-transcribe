(
~getFrequencies = {|in|
    var out;
    var cond = Condition.new;
    var outBuf = Buffer.new;
    FluidBufPitch.process(s, in, features: outBuf,
        action:{outBuf.loadToFloatArray(
            action: {|x|
                out = x.reshape((x.size()/2).asInteger, 2);
                cond.unhang;
            }
        )
        }
    );
    cond.hang;
    out
};

fork{
    b = Buffer.read(s, File.realpath(FluidBufPitch.class.filenameSymbol).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-ASWINE-ScratchySynth-M.wav");
    s.sync;
    ~getFrequencies.value(b).postln;
}
)