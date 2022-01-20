~main.buffer.loadOnsets("/Users/james/Samples/Local/loops/03-John_Coltrane-Jupiter.wav", 0);
~main.buffer.loadOnsets("/Users/james/Samples/Local/loops/jazz.wav", 1);
~main.buffer.loadOnsets("/Users/james/Samples/Local/portioncontrol/portion control - operator -sample pack- - 07 pc_110_bell_end.wav", 2);
~main.buffer.loadOnsets("/Users/james/Samples/Local/Iterations/cavern.wav", 3);
~main.buffer.loadOnsets("/Users/james/Samples/Local/Iterations/drumbo-bat-chain-puller-1.wav", 3);

~main.onsetBuffers[0];
~main.onsetBuffers[0];
Index.kr(~main.onsetBufferIndices[0]);

File.realpath(FluidBufOnsetSlice.class.filenameSymbol).dirname.withTrailingSlash ++ "../AudioFiles/Nicol-LoopE-M.wav");