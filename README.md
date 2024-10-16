# Let's Fight a Dragon with Godot

This project was made by Kristian Hiim for a presentation called "Let's Fight a Dragon with Godot" for the Hello Stavanger 2024 conference. The code is available here for you to study and learn. If you have any questions about the code, or want to discuss game programming in general, feel free to contact me.

## License details

See [LICENSE.txt](./LICENSE.txt) for details.

## Importing the project in Godot

This project was developed with the Godot game engine, version 4.3. Go to [Download Godot 4.3](https://godotengine.org/download/archive/4.3-stable/), and download the standard version for your OS. Run Godot and import this project.

## Project structure

There are four main folders in this projects:
* `/assets` contains graphics and sound effects.
* `/resources` contains any reusable resources. This folder only contains two tilesets, that are used to draw tiles on tilemaps.
* `/scenes` contains all the scenes in the project.
* `/scripts` contains all scripts.

There are two main scenes. The default scene is the first level, located at `/scenes/levels/volcano/volcano.tscn`. This is the scene that will start if you simply open and run the project. The slides used in the presentation are found at `/scenes/slides/slides.tscn`. They can be started opening the scene and use the "Run Current Scene" function.

The player character scene can be found at `/scenes/player/player.tscn`. This is the scene that represents the main character that we control in the game.

## Controls

This game requires a keyboard and mouse to play. Move left and right with **A** and **D**. Jump with **SPACE**. Attack using the keyboard with **SHIFT** or **CTRL**. Fire the current ranged weapon with the **left mouse button**. Aim the gun using the **right mouse button**.

Fullscreen can be toggled with **F11**. The ranged weapon can be switched using **2** when standing still. *(Moving while holding a gun is not implemented, as I didn't have time to create any more animations.)*

## Credits

The graphics and code in this project were created by me, Kristian Hiim, with the exception of the three types of bugs encountered on the way to the dragon, which were drawn by my children.

The sound effects were downloaded from various free sources. See the license information for details.