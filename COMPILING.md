# Compiling the Game
This is a guide on how to properly compile the game's source code. Follow the steps carefully, so you don't experience any issues.

## Dependencies
* Install [Haxe 4.2.5](https://haxe.org/download/version/4.2.5/)
* Open command prompt and run the commands `haxelib install hmm` and `haxelib run hmm setup`.
* From the source code directory, run the command `hmm install`. A tip for doing this step is that if you have command prompt open still, you can run `cd (source code directory location)`.

## Platforms
### Windows
* Install Visual Studio 2019.
* Once you get the option, click `Individual components`, select `MSVC v142 - VS 2019 C++ x64/x86 build tools` and `Windows SDK (10.0.17763.0)`.
### MacOS
* Install the latest version of Xcode from the MacOS App Store.
### Linux
* Install g++. If you want to compile the game in 32-bit, you will also need `gcc-multilib` and `g++-multilib`.

## Commands
Congratulations on managing to complete the previous steps. Now you can finally compile the game! From the source code directory, run `lime test [target]` in command prompt.
Replace `[target]` with the platform you're compiling for. Ex. `windows`, `mac`, `linux`, `android`, etc. To compile the game in debug mode, add `-debug` at the end of the command line.

I hope this was helpful and that everything went well. If you've had any issues, please report them.
