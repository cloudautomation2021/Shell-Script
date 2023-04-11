#!/usr/bin/env bash

##########################################################################
#         Author : Rupesh Kolatwar                                       #
#         Date   :                                                       #
#         Usage  : START slashdb/nginx           #
##########################################################################

#sudo systemctl start slashdb.service
#sudo systemctl start nginx.service

#prerequisites
#1)touch pass_file (for keep  password )
#2)touch remote_servers.txt ( contains  List of server )


App_user="app_user"

ssh_connect="sshpass -f pass_file ssh -n -o StrictHostKeyChecking=no -o PubkeyAuthentication=no $App_user"

while read remote_servers

     do
        echo -e "\034[1;33mConnected  On Server: \033[0m" $remote_servers

          echo -e "\033[1;33mStarting service nginx On Server: \033[0m" $remote_servers

            nginx_service_start=$($ssh_connect@$remote_servers "sudo systemctl start nginx.service")

                nginx_process_check=$($ssh_connect@$remote_servers "ps aux | grep nginx")

                   if [[ $? -eq 0 ]]

                 then

               echo -e '\033[1;32mprocess nginx Started\033[0m'

           else

       echo -e '\033[1;31mProcess nginx not Started\033[0m'
fi

     echo -e "\033[1;33mStarting service slashdb On Server: \033[0m" $remote_servers

        slashdb_service_start=$($ssh_connect@$remote_servers "sudo systemctl start slashdb.service")

            slashdb_process_check=$($ssh_connect@$remote_servers "ps aux | grep slashdb")

               if [[ $? -eq 0 ]]

                 then

                  echo -e "\033[1;32mprocess slashdb Started\033[0m"

                     else

                       echo -e "\033[1;31mProcess slashdb not Started\033[0m"

                          fi
done < remote_servers.txt
