Chat Does Pixel Art

This project is a blank canvas(pun intended). Please if there is anything you would like to see, feel free to create an issue, or add it yourself!



Dependencies:

[Godot](https://godotengine.org/)

[Streamer.bot](https://streamer.bot/) with the UDP Server setup. Port: 4242

The only supported data at this point is:
`x y palette_index` which equates to `%input0% %input1% %input2%` for the streamer.bot UDP Payload.


For example in my instance of streamer.bot my twitch command looks like this:

`!p x y palette_index`


