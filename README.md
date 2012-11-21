obj-c-reaktor
==========

Objective-C client (iOS and Mac OS X) for reaktor.io.

Builds a universal framework.

Project-Structure
=========

The project contains a src and a bin folder. bin always contains the altest builds build with the universal reaktor target, whereas src contains all source files.
The targets are splitted into a basic reaktor-target which just builds the iOS- and the Mac-OS-X-targets, merges and copies the build into the project-folder. We always try to write code which can be executed on both, iOS and Mac OS X, so the subfolders ios-reaktor and mac-reaktor are empty - besides the prefix-file.