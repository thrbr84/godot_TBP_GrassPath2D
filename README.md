# Godot - TBP_GrassPath2D

- Developed and tested on Godot 3.2
- [Portuguese documentation](README_PT-BR.md)
- Tested with GLES2 and GLES3 (PC and Android)
- FPS varies a lot according to the configuration of the interval between the "leafs" and the parameter "maxProcess" which is the maximum number of physics processes for the grass segment.

Interactive grass generator through a Path2D (Curve).

### Plugin parameters
------
CAUTION!!!
interval: this parameter if less than 15 can significantly lose performance in conjunction with the "interactive" parameter if enabled.

For better performance, increase the value of "interval", which is the interval between the "leafs", and adjust the process limit to "maxProcess" physics
------
- ```interval```: Space between "leafs"
- ```interactive```: If enabled, interact with objects in the group "groupInteractive"
- ```maxProcess```: Maximum processes for leaf physics that interact at the same time


- ```colorGrass```: Color array for "leafs" - Textures reported in "grassTextures" must be white
- ```blur_samples```: Blur sample
- ```blur_strength```: Blur strength - 0 à 1
- ```colorTerrain```: Terrain color, if generated
- ```generateTerrain```: Generates a StaticBody terrain with collision
- ```maxHeightTerrain```: Maximum height in pixels for the generated terrain
- ```interactiveArea```: A pixel "width" for the "leaf" area to interact with the object
- ```followAngle```: Whether the "leaf" should follow the rotation of the terrain curve
- ```heightGrass```: Grass height
- ```randomGrassMin```: Minimum range to randomize leaf rotation
- ```randomGrassMax```: Maximum range to randomize leaf rotation
- ```windForce```: Power to the wind
- ```windDirection```: Wind direction, -1 to the left and 1 to the right
- ```grassZIndex```: Index for the Z Index of the leafs
- ```grassYOffset```: Y offset for leafs
- ```maxLeafRotateDegree```: Maximum (º) degree for leaf rotation
- ```grassTextures```: Array that will be randomized between leafs
- ```groupInteractive```: String array with the name of the group that the "leaf" should interact with, that same group must be in the object

----------

### Demonstration Video (PT-BR)
- https://www.youtube.com/watch?v=6wFHC3af164

[![Demonstration](https://img.youtube.com/vi/6wFHC3af164/0.jpg)](https://www.youtube.com/watch?v=6wFHC3af164)

----------

##### Example
- In the project example, I show how to use the plugin, to move the "player" on the PC, use the arrows keys, and the space to jump. 
- It is also possible to run on Android, just click and drag to move the "player", and with the analog stick tap with a second finger to jump.

----------

##### Configure the Addon
- Download the folder [addons/TBP_GrassPath2D](addons/TBP_GrassPath2D)
- Put it in your project's "addons" folder
- Go to Project Settings > Plugin and enable the "TBP_GrassPath2D" plugin

----------

##### AnimationPlayer

You can use an AnimationPlayer or GDScript to change some parameters at run time, for now, you can change the following parameters:

- heightGrass
- windDirection
- windForce

----------

### ...
Will you use this code commercially? Rest assured you can use it freely and without having to mention anything, of course I will be happy if you at least remember the help and share it with friends, lol. If you feel at heart, consider buying me a coffee heart -> https://ko-fi.com/thsbruno

