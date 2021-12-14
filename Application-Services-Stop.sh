#!/bin/bash
##########################################################################
#         Author : Rupesh Kolatwar                                       #
#         Date   :                                                       #
#         Usage  : STOP  slashdb/nginx Application Services              #
##########################################################################
#sudo systemctl stop slashdb.service
#sudo systemctl stop nginx.service
#remove /var/log/slashdb/uwsgi.pid


#prerequisites
#1)touch pass_file (for keep  password )
#2)touch remote_servers.txt ( contains  List of server )

App_user="application_user"

ssh_connect="sshpass -f pass_file ssh -n -o StrictHostKeyChecking=no -o PubkeyAuthentication=no $App_user"

while read remote_servers

        do
           echo "---------------------------------------------------------------------------------------"

             echo -e "\033[1;33mConnected  On Server: \033[0m" $remote_servers

              echo "---------------------------------------------------------------------------------------"

                echo -e "\033[1;33mStopping  service slashdb On Server: \033[0m"

                slashdb_service_stop=$($ssh_connect@$remote_servers "sudo systemctl stop slashdb.service")

                slashdb_process_check=$($ssh_connect@$remote_servers "ps cax | grep slashdb")

                if [[ $? -eq 0 ]]

                    then

                 echo -e "\033[1;32mprocess slashdb running \033[0m"

            else

        echo -e "\033[1;31mProcess slashdb stop successfully\033[0m"
fi

        echo -e "\033[1;33mStopping service nginx On Server: \033[0m"

              nginx_service_stop=$($ssh_connect@$remote_servers "sudo systemctl stop nginx.service")

              nginx_process_check=$($ssh_connect@$remote_servers "ps cax | grep nginx")

                 if [[ $? -eq 0 ]]

                     then

                        echo -e '\033[1;32mprocess nginx running \033[0m'

                    else

                echo -e '\033[1;31mProcess nginx stop successfully\033[0m'

            fi

        file_check=$($ssh_connect@$remote_servers "sudo find / -type f -name uwsgi.pid")


    echo "$file_check" >/dev/null

echo "---------------------------------------------------------------------------------------"

if [[ ! -z "$file_check" ]]

          then

            file_remove=$($ssh_connect@$remote_servers "sudo rm -rf $file_check")


              echo "FOUND uwsgi.pid file '$file_check'deleted on: " $remote_servers

               else

                  echo "File uwsgi.pid not  FOUND on Server: "$remote_servers

                        fi
echo "---------------------------------------------------------------------------------------"
done < remote_servers.txt
