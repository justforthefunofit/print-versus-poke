100 s$="{64}{64}{64}{64}{64}{64}{76}{64}{18}{96}{146}{76}{64}{18}{96}{146}{67}{67}{64}{67}{67}{64}{79}{18}{191}{96}{146}{79}{18}{191}{96}{146}{57}{18}{188}{176}{146}{57}{18}{188}{176}{146}"
110 s$=s$+"{18}{191}{191}{188}{191}{191}{188}{111}{191}{188}{108}{146}{64}{18}{108}{108}{146}{64}{18}{108}{146}{67}{18}{111}{146}{64}{67}{18}{111}{146}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}{64}"
120 ::
130 poke 53269,  1 :rem sprite 1 visible
140 poke 53287,  3 :rem color = 3
150 poke  2040,192 :rem pointer to 192x64 = 12288
160 poke 53248, 44 :rem x pos sprite
170 poke 53249,120 :rem y pos sprite
180 poke 53277,  1 :rem sprite width
190 poke 53271,  1 :rem sprite height
210 ::
600 poke 648,48 : rem set edit location
610 poke 53272,(peek(53272)and15)or192: rem new screen location
620 ?chr$(147);s$: rem program the sprite memory
700 poke 648,4: rem  edit to original
710 poke 53272,(peek(53272)and15)or16:rem restore screen location
