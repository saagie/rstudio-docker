# RStudio Server - customized by Saagie

This image is based on official [rocker/rstudio](https://hub.docker.com/r/rocker/rstudio/) image.
It adds a few feature, such as:
* [sparklyr](https://spark.rstudio.com/index.html): Connect to [Spark](http://spark.apache.org/) from R
* [Saagie Add-in](https://github.com/saagie/rstudio-saagie-addin): allows you to push R jobs to Saagie's platform
* Ability to create multiple user accounts

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
Then go to '*Tools > Shell*' and run the following commands:
```
~$ sudo useradd my_new_user --home /home/my_new_user --create-home --groups rstudio
~$ sudo passwd my_new_user
(then enter the desired password twice when requested)
```
Replace `my_new_user` with the user's login you want to create.
