ls -la
pwd
exit
ls exit
exit
ls -la
hop-run.sh   --file=/opt/hop/workspace/pipelines-and-workflows/main.hwf   --runconfig=classic   --parameters=PARAM_TEST=Hello
./hop-run.sh   --file=/home/hop/workspace/pipelines-and-workflows/main.hwf   --runconfig=classic   --parameters=PARAM_TEST=Hello
hop-run.sh   --file=/home/hop/workspace/pipelines-and-workflows/main.hwf   --runconfig=classic   --parameters=PARAM_TEST=Hello
./hop-run.sh   --file=/home/hop/pipelines-and-workflows/main.hwf   --runconfig=classic   --parameters=PARAM_TEST=Hello
/hop-run.sh   --file=/home/hop/pipelines-and-workflows/main.hwf   --runconfig=classic   --parameters=PARAM_TEST=Hello
hop-run.sh   --file=/home/hop/pipelines-and-workflows/main.hwf   --runconfig=classic   --parameters=PARAM_TEST=Hello
exit
pwd
exit
pwd
cd ~
ls -la
echo $HOP_CONFIG_DIRECTORY 
echo $HOP_RUN_CONFIG 
export HOP_CONFIG_DIRECTORY=~/config/hop/config/
cd /opt/project-hop/hop/
./hop-run.sh   --file=/home/hop/pipelines-and-workflows/main.hwf   --environment=project-a-dev   --runconfig=classic   --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
exit
