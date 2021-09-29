//create a monitoring bus for the descriptors
b = Bus.new(\control,0,4);

//create a monitoring window for the values
(
w = Window("Frequency Monitor", Rect(10, 10, 220, 115)).front;

c = Array.fill(4, {arg i; StaticText(w, Rect(10, i * 25 + 10, 135, 20)).background_(Color.grey(0.7)).align_(\right)});
c[0].string = ("FluidPitch: ");
c[1].string = ("confidence: ");
c[2].string = ("SC Pitch: ");
c[3].string = ("Confidence: ");

a = Array.fill(4, {arg i;
    StaticText(w, Rect(150, i * 25 + 10, 60, 20)).background_(Color.grey(0.7)).align_(\center);
});
)

//routine to update the parameters
(
r = Routine {
    {

        b.get({ arg val;
            {
                if(w.isClosed.not) {
                    val.do({arg item,index;
                        a[index].string = item.round(0.01)})
                }
            }.defer
        });

        0.1.wait;
    }.loop

}.play
)

//test signals, all in one synth
(
x = {
    arg freq=220, type = 0, noise = 0;
            var source = PinkNoise.ar(noise) + Select.ar(type,[SinOsc.ar(freq,mul:0.1), VarSaw.ar(freq,mul:0.1), Saw.ar(freq,0.1), Pulse.ar(freq,mul:0.1), Mix.new(Array.fill(8, {arg i; SinOsc.ar(LFNoise1.kr(0.1.rand,10,220*(i+1)),mul:(i+1).reciprocal * 0.1)}))]);
    Out.kr(b, FluidPitch.kr(source) ++ Pitch.kr(source));
    source.dup;
}.play;
)

// the built-in is slightly better on pure sinewaves
x.set(\freq, 440)

// adding harmonics, by changing to triangle (1), saw (2) or square (3) shows that spectral algo are more resilient when signal are richer
x.set(\type, 1)
x.set(\type, 2)
x.set(\type, 3)

// adding noise shows the comparative sturdiness of the spectral pitch tracker
x.set(\noise, 0.05)

//if latency is no issue, getting a higher windowSize will stabilise the algorithm even more