# FontProfileBuilder
Script and associated templates to create a .mobileconfig profile with a group of fonts for deployment to macOS devices.

_Important Note: add the fonts to the same directory as the script and templates or vice versa and make sure there are no spaces in the pathname of that directory._

Font profile template and modified from this [article](https://lindenbergsoftware.com/en/notes/installing-fonts-on-ios/index.html) from Lindenberg Software.

Known Issues that I may or may not fix:
1. Script breaks if run from a directory path with spaces
    - This may be an easy one but I don't have enough experience scripting to know a quick fix.
2. Font files must be in the same directory as the script.
    - Because this was a quick weekend project to get our Communications department up and running with some fonts I didn't bother with trying to allow for an "input" directory.
3. It's ugly as sin and the resulting profile is ridiculous
    - I'm not sure what to do about this. My experience with profiles is that it's hard to make them look nice and readable when smushing them around with scripts. Maybe I'll come across a good solution one day.