SudokuBlocks.app from one year ago will not run on macOS Sierra.  Aggravating, but there it is.  So I decided to upgrade the app to Swift3.  

This was a bit of a challenge.  The biggest thing is that automatic code migration didn't appear to work well at first, and also Xcode was complaining about some project settings, which I didn't know how to make right. 

I made a brand new project, set up new xib files, and then added the old Swift files to it.  I did this in two phases, in the first one there was just enough of the code to load a puzzle and draw it on the screen.

I tried to build the project and then fixed the errors one by one.  I probably had 50 errors in phase 1 and 100 in phase 2.  Xcode was really good at telling me what was wrong and often making the fix as simple as a double-click.

I ran into an additional bug where the view would not update properly, but I solved that.

[Since then I have tried again with letting Xcode try to fix the project, and it worked a lot better.  I got the app to the state where it would run in about 20 minutes versus most of a day to rebuild it from scratch.]