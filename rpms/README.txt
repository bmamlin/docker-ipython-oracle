BYOICR = Bring Your Own Instant Client RPMs

For this build to work, you will need to supply your own RPMs for Oracle's Instant Client Basic Lite and SDK packages for Linux x86-64. These are only available once to you once you have registered an Oracle account and agreed to their license agreement.

If you haven't already, register for an Oracle account.

Once logged in to Oracle's website, go to Instant Client Downloads for Linux x86-64. You will need to accept their license agreement before you can download anything.

Pay close attention to version number and file names. For this repository, I am using version 11.2. You want to download two file: Basic Lite and SDK RPMs (file name should end with .rpm).

Place these two files into this folder, so they can be used when building the docker image.