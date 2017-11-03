# RStudio Server - customized by Saagie

This image is based on official [rocker/rstudio](https://hub.docker.com/r/rocker/rstudio/) image.
It adds a few feature, such as:
* [sparklyr](https://spark.rstudio.com/index.html): Connect to [Spark](http://spark.apache.org/) from R
* [Saagie Add-in](https://github.com/saagie/rstudio-saagie-addin): allows you to push R jobs to Saagie's platform
* Ability to create multiple users accounts

## Run RStudio container

Simply run:
`docker run --rm -it -p8787:8787 -v $PWD/rstudio:/home --name rstudio saagie/rstudio:latest`

Then you'll be able to access RStudio at http://localhost:8787 using the default user (login: rstudio, password: rstudio).
Mounting a volume to `/home` directory allows you to persist every RStudio user projects and settings. Meaning the `-v $PWD/rstudio:/home` part is optional but can be useful.

If you want to use [sparklyr](https://spark.rstudio.com/index.html) you'll need to mount a few volumes to share your cluster configuration with your container.
In this case, try something like:
`docker run --rm -it -p8787:8787 -v $PWD/rstudio:/home -v $PWD/hadoop/conf:/etc/hadoop/conf --name rstudio saagie/rstudio:latest`

## Create new RStudio users

If you want to create new RStudio users, you'll need to log in to RStudio as: admin (password: rstudioadmin).
Then go to '*Tools > Shell*' and run `sudo adduser my_new_user`.
You'll be prompted to enter admin's password, and then to chose your new user's password. No need to fill in the other fields.
If you want to allow this new user to install libraries, you need to add him to the *staff* group using the following command: `sudo adduser my_new_user staff`.

**Important note:** After you created a new user, remember to run `./backupusers`. This will backup users info in a tarball. If you add mounted a volume to `/home`, every user will be recreated on next container startup.
