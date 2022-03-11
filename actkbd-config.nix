{ pkgs, ... }:

{
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 113     ]; events = [ "key" ]; command = "pactl set-sink-mute   @DEFAULT_SINK@ toggle"; }
      { keys = [ 114     ]; events = [ "key" ]; command = "pactl set-sink-volume @DEFAULT_SINK@ -5%"; }
      { keys = [ 115     ]; events = [ "key" ]; command = "pactl set-sink-volume @DEFAULT_SINK@ +5%"; }
      { keys = [ 29  114 ]; events = [ "key" ]; command = "pactl set-sink-volume @DEFAULT_SINK@ -2%"; }
      { keys = [ 29  115 ]; events = [ "key" ]; command = "pactl set-sink-volume @DEFAULT_SINK@ +2%"; }
      { keys = [ 42  114 ]; events = [ "key" ]; command = "pactl set-sink-volume @DEFAULT_SINK@ 20%"; }
      { keys = [ 42  115 ]; events = [ "key" ]; command = "pactl set-sink-volume @DEFAULT_SINK@ 155%"; }
      { keys = [ 116     ]; events = [ "key" ]; command = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"; }
    ];
  };
}
