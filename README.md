# Monopoly - Banking Unit

This is basically for all those who play Monopoly but don't want to deal with cash.
Incomplete
- The 'rent' function still doesn't work, but I could adjust with the rest of the functions, so I was lazy to complete the whole thing.
- I still have to register all the properties/title deed cards, and store their data(rent value, mortgage value, etc.)

## A Gist of the app
Obviously, from the quality of the app, this was only meant for my personal use - so it was specifically tailored for Monopoly Go! (not the video game)
The app requires each player to have an NFC tag (which I had plenty lying around, don't ask why) for themselves.
The players first register their cards, and each player starts with $1500. Then you can give other players money (as of now, by the first player giving money to the bank, and then the second taking money from the bank), or 'pass go' or 'pay bail', etc.

## I know, it's terrible right now...
...which is why I'm building another one from scratch, with an easier drag-and-drop interface instead of players having to tap physical cards, and a better UX in general.

## How do you run this?
You could import this project into Android Studio. Just make sure the the Flutter and Dart plugins are enabled. Then you may connect your Android device through a USB cable (or enable wireless debugging), and run the project. Alternatively, you could use an Android emulator, or use VS Code instead of Android Studio.
