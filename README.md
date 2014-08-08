docker-ipython-oracle
=======================

Docker container image capable of running an iPython notebook server with ability to access an Oracle database.

Prerequisties
-------------
You installed [Git](http://git-scm.com/) and [Docker](https://docs.docker.com/installation/). 
If you are on OS X or Linux, you may already have git installed (open a terminal and type the
command `git --version`; if it returns a version number, you've already got git).

Step One: Clone this repository
-------------------------------
First, clone a copy of this repository:

    git clone https://github.com/bmamlin/docker-ipython-oracle

This will make a `docker-ipython-oracle` folder with a copy of the contents of this repository.


Step Two: BYOICR = Bring Your Own Instant Client RPMs
-----------------------------------------------------
For this build to work, you will need to supply your own RPMs for Oracle's Instant Client Basic Lite and SDK packages for Linux x86-64.  These are only available once to you once you have registered an Oracle 
account and agreed to their license agreement.

1. If you haven't already, [register for an Oracle account](https://login.oracle.com/mysso/signon.jsp).

2. Once logged in to Oracle's website, go to [Instant Client Downloads for Linux x86-64](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html).  You will need to accept their license agreement before you can download anything.

3. Pay close attention to version number and file names.  For this repository, I am using version 11.2.  You want to download two file: Basic Lite and SDK RPMs (file name should end with .rpm).

4. Temporarily place these files where they can be fetched from the web.  I used Dropbox and copied the links into the Dockerfile.  Once the image is built, you can delete this files.

NOTE: It is not sufficient to simply provide links to the Oracle page, since you must be 
authenticated and have agreed to the licensing terms to access the files.  Likewise, you 
shouldn't be permanently posting or publicly sharing links to these files, since that would 
be breaking the licensing agreement.

Step Three: Edit your Dockerfile
--------------------------------
Since the Oracle Instant Client RPMs are not publicly available on the web, you need to edit your 
Dockerfile and provide links to your own, personal copies of these RPMs.  From Step Two, you 
should have two links in hand: one for the Basic Lite RPM and the other for the SDK RPM.

Open the `Dockerfile` file in your favorite text editor and replace these two links in the wget 
commands in the middle of the file:
* `https://replace/with/link/to/oracle-instantclient11.2-basiclite-11.2.0.4.0-1.x86_64.rpm`
* `https://replace/with/link/to/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm`

If you're links are correct, browsing to either of them in your browser should begin 
downloading the RPM file.

NOTE: the exact version (numbers beyond the "11.2") may vary.  If you want to use IPython to 
connect to a different version of Oracle, then you'll want to use the corresponding version 
and will need to edit the three other places in the Docker file where the versino ("11.2") is 
mentioned to match your version.

Step Four: Build your image
---------------------------
Within the folder containing Dockerfile, type this command:

    docker build -t ipython .

This is the longest step (can take 5-10 minutes or more depending on your computer and your 
internet connection.  You'll see a lot of stuff scrolling by and a few obscure, python-related 
error messages that can be ignored.  Ideally, it will end with a message saying that the image 
was successfully built.  Lines like `Successfully installed cx-oracle` are reassuring to see as 
well.  If it fails to build, look at the output to try to sort out the problem.  Did it fail to 
find either of your RPMs?  Use `docker ps -a` to list out any failed containers and remove them 
with `docker rm ID_OR_NAME`.  Use `docker images` to list any images.  You can leave the ubuntu 
image (so it doesn't need to get downloaded again), but you can remove any unnamed images with 
`docker rmi ID`.  Note that you only need to type the first few characters in an ID for docker 
to unambiguously recognize it.

Step Five: Start your docker container
--------------------------------------
Type this command:

    docker run -d -p 80:8080 --name ipython ipython

The `-d` tells docker to run as a background daemon, so you return immediately to the command 
line.  The `-p 80:8080` tells docker to map port 8080 (exposed by the image, see Dockerfile) 
as port 80 on the host.  `--name ipython` gives the container a convenient name.  And the 
`ipython` at the end refers the image you built in Step Four.

Step Six: Profit
----------------
You should now be able to use your IPython Notebook.  If you are in Windoze or Mac using 
[boot2docker](https://github.com/boot2docker/boot2docker), then use the command `boot2docker ip` 
to find the IP address of your virutal host machine (usually something like `192.168.59.103`, but 
ymmv).  Assuming you find IPython waiting for you at that address, you can use a recipe like 
this to reach your Oracle database:

    %load_ext sql
    %sql oracle://username:password@hostname:1521/sid

    # Assuming that got you connected, you can start issuing SQL commands like
    %sql SELECT * FROM PRODUCT_COMPONENT_VERSION
