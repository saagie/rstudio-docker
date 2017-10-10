#!/bin/bash

echo "Init RStudio"

/init &

# wait a bit for initialization to end before modifying the users...
sleep 5

echo "Init users"

# We need to make rstudio user the owner of his own home directory as it will be owned by root if we mount a docker volume to /home (weird but true...)
mkdir -p /home/rstudio
chown -R rstudio:rstudio /home/rstudio
chmod -R 755 /home/rstudio

# create an admin user who will be able to create new users directly from RStudio IDE
useradd admin --home /home/admin --create-home -p $(openssl passwd -1 rstudioadmin) --groups sudo,shadow,rstudio

# Add backupusers script for admin user
mkdir -p /home/admin
echo "sudo tar cf /home/admin/users_backup.tar /etc/passwd /etc/shadow 2> /dev/null" > /home/admin/backupusers
chown admin:admin /home/admin/backupusers
chmod 700 /home/admin/backupusers

# then restore previous users if necessary
if [ -e /home/admin/users_backup.tar ]
then
    echo "Restoring users..."
    rm -rf /tmp/userrestore
    mkdir -p /tmp/userrestore

    tar xf /home/admin/users_backup.tar -C /tmp/userrestore --strip-components=1

    cat /tmp/userrestore/shadow | while read LINE
    do
      # echo $LINE

      USER=$(echo $LINE | awk -F':' '{print $1}')
      ENCRYPTED_PASSWD=$(echo $LINE | awk -F':' '{print $2}')

      if ! grep -q "^$USER:" /etc/passwd
      then
        echo "- restoring $USER"
        HOME_DIR=$(grep "^$USER:" /tmp/userrestore/passwd | awk -F':' '{print $6}')
        echo "   home dir: $HOME_DIR"
        useradd $USER --home $HOME_DIR --create-home -p $ENCRYPTED_PASSWD
        chown -R $USER:$USER $HOME_DIR
      fi

    done
fi

# keep the container running...
tail -f /dev/null
