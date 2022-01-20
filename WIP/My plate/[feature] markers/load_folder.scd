~source_files_folder = "/Users/james/Samples/Local/mykit/bongo/";

FileDialog({ |n| ~source_files_folder = n; ~source_files_folder.postln}, stripResult: true, path: "/Users/james/Samples/Local/");
// folder
~loader = FluidLoadFolder(~source_files_folder);

(
~loader.play(s,{
	~source_buf = ~loader.buffer;
	"all files loaded".postln;
	"num channels: %".format(~source_buf.numChannels).postln
});
)

~source_buf.play;
~source_buf.plot;
~source_buf.numChannels;
~loader;

Buffer