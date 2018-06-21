##############################################
##  !/bin/bash
## __     __   __     ______   ______    
##/\ \   /\ "-.\ \   /\  ___\ /\  __ \   
##\ \ \  \ \ \-.  \  \ \  __\ \ \ \/\ \  
## \ \_\  \ \_\\"\_\  \ \_\    \ \_____\ 
##  \/_/   \/_/ \/_/   \/_/     \/_____/ 
##
##  - Checks fileage
##  - if a file exceeds the max age, 
##    the content will be overwritten
##  - creates logs what it does
##
##  Script author:
##  https://github.com/Deadalus3010
##
##  comparedate() from ashrithr:
##  https://gist.github.com/ashrithr/5614283
##
##  displaytime() from Stéphane Gimenez:
##  https://unix.stackexchange.com/users/9426/st%c3%a9phane-gimenez
##  https://unix.stackexchange.com/questions/27013/displaying-seconds-as-days-hours-mins-seconds
##
##############################################

clearlogascii() {
cat << EOT
   _____ _                 _                 
  / ____| |               | |                
 | |    | | ___  __ _ _ __| |     ___   __ _ 
 | |    | |/ _ \/ _' | '__| |    / _ \ / _' |
 | |____| |  __/ (_| | |  | |___| (_) | (_| |
  \_____|_|\___|\__,_|_|  |______\___/ \__, |
                                        __/ |
                                       |___/
EOT
}
clearlogascii

##############################################
##
##
## Including the files 'logclear.config' and 'logclear.lang'
MYDIR=$(dirname $(readlink -f $0))
##
. "$MYDIR"/clearlog.config
. "$MYDIR"/clearlog.lang     
##
## 
##############################################
#
#           __         ____             __ 
#     _____/ /_       / __ )____ ______/ /_
#    / ___/ __ \     / __  / __ `/ ___/ __ \
# _ (__  ) / / /    / /_/ / /_/ (__  ) / / /
#(_)____/_/ /_/    /_____/\__,_/____/_/ /_/
#               
#
################BEGIN TOOLBOX#################

#funtion arguments -> filename to compare against curr time
function comparedate() {
if [ ! -f $1 ]
then

   echo -e "${LANG_COMPAREDATECHECK}\n"
	   exit 1

fi

#MAXAGE=$(bc <<< '60')
#Fileage in seconds = current_time - file_modification_time.
FILEAGE=$(($(date +%s) - $(stat -c '%Y' "$1")))
test $FILEAGE -lt $MAXAGE && {
    #Less then Maxage
    return 0
}
#More then Maxage
return 1
}

#When more the 60 Seconds are shown in the console / clearlog.log file,
#this automatically convert seconds to DAYS // HOURS // MINUTES // SECONDS format. 
#Important for the date

function displaytime() {

  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))

  (( $D > 0 )) && printf "%d $DATEOUTPUTD " $D
  (( $H > 0 )) && printf "%d $DATEOUTPUTH " $H
  (( $M > 0 )) && printf "%d $DATEOUTPUTM " $M

  (( $D > 0 || $H > 0 || $M > 0 )) && printf "and "

  printf "%d $DATEOUTPUTS\n" $S

}

##################END TOOLBOX#################

#Text jumps one line down
echo -e "\n"

#Checks, if we allow Script logs
if [ $LOGALLOW -eq 1 ]
then
   #Checks, if the Script log file exists
   for i in $LOGPATH$LOGFILE
   do
       echo ${LANG_CHECKLOGFILE}
       if [ -f $i ]
       then

           echo -e ${LANG_LOGFILEFOUND}

       else

           echo -e ${LANG_LOGFILENOTFOUND}
           touch $LOGPATH$LOGFILE

	   if [ ! -f $i ]
           then

	         echo ${LANG_LOGFILECREATEERROR}

	   fi

           #Pastes the clearlog Ascii art once in the Script log file at the beginning
	   clearlogascii >> "$LOGPATH""$LOGFILE"
           #Writes the path, where the log file is located in the Script log file
	   echo "<"$FILEDATE"> "$LOGPATH""$LOGFILE" ${LANG_LOGFILEPATHCREATE}" >> "$LOGPATH""$LOGFILE"

        fi
   done
fi

#Checks, if we allow the already cleared files to move in another folder
if [ $CLEARMOVEFILEALLOW -eq 1 ]
then
   #Checks, if the folder exists
   for i in $CLEARMOVEPATH$CLEARMOVEDIRECTORY
   do
       echo ${LANG_CHECKMOVEFOLDER}
       if [ -d $i ]
       then

           echo ${LANG_MOVEFOLDERFOUND}

       else

           echo -e ${LANG_MOVEFOLDERNOTFOUND}
           mkdir $CLEARMOVEPATH$CLEARMOVEDIRECTORY

	   if [ ! -d $i ]
           then
	         echo ${LANG_MOVEFOLDERCREATEERROR}
	   fi

           #Checks, if we allow logs
           if [ $LOGALLOW -eq 1 ]
           then
	
	      #Writes the path, where the folder located in the Script log file
	      echo "<"$FILEDATE"> "$CLEARMOVEPATH""$CLEARMOVEDIRECTORY" ${LANG_MOVEFOLDERCREATE}" >> "$LOGPATH""$LOGFILE"
	
           fi


        fi
   done
fi

   if [ ! -f $CLEARPATH$CLEARNAME ]
   then

      echo -e "${LANG_FILEDONTEXISTS}\n"
      FILECOUNT=0

   else

      #Counts, how many files are in the folder (For Consolen Ausgabe + Script Log)
      FILECOUNT=`find $CLEARPATH$CLEARNAME -type f | wc -l`

   fi

   #Logs how many files are in the folder, displays the maxage, if we allow Script logs, if we allow to move old logs, if we allow deleting old log files.
   echo -e ""$FILECOUNT" ${LANG_DEBUG}"

   #Do we allow Script logs?
   if [ $LOGALLOW -eq 1 ]
   then

   #Logs how many files are in the folder, displays the maxage, if we allow Script logs, if we allow to move old logs, if we allow deleting old log files.
   #And writes it in the Script log file
   echo -e "\n"$FILECOUNT" ${LANG_DEBUG}" >> "$LOGPATH""$LOGFILE"

   fi

   #This line is for debug purposses
   echo -e "\n...${LANG_CHECKAGE}...\n"

   #Variable declaration for the file counter (Only Console)
   LFNR=1

#Calls each file individually,  starting with CLEARNAME.
#Runs until it finds no more CLEARNAME file.
#Filename is the name the function has just read
for FILENAME in $CLEARPATH$CLEARNAME
do

   #Output number of file currently being edited (Only Console)
   #Increment the file counter
   echo ""$LFNR". ${LANG_FILENAME}"
   let LFNR=$LFNR+1

   #Call the function to determine the age of the log files.
   comparedate $FILENAME
   AGE="$?"

   #Console Output
   echo -e "${LANG_FILENAME}: "$FILENAME" \t${LANG_CLEARCHECK}"

   #If method checking the return value of the age
   if [ "$AGE" -eq 1 ]
   then 

	#Console Output
	echo -e "<"$FILEDATE"> ${LANG_CLEAR}, ${LANG_FILEAGE}: "$(displaytime $FILEAGE)".\n"

	#Overwriting the file content
	echo -e "<"$FILEDATE"> - $FILENAME ${LANG_CLEARDELETE} ${LANG_FILENAME} was "$(displaytime $FILEAGE)" ${LANG_FILEAGE2}. \n\t\t\t\t\t"$(displaytime MAXAGE)" ${LANG_MAXAGEEXCEEDED}." > "$FILENAME"
	
	#Do we allow moving the old files into another folder?
	if [ $CLEARMOVEFILEALLOW -eq 1 ]
	then

           #Moved the file to the folder
           echo -e "Move: "$FILENAME" - ${LANG_MOVETO} - \n"$CLEARMOVEPATH""$CLEARMOVEDIRECTORY". \n"
	   mv $FILENAME $CLEARMOVEPATH$CLEARMOVEDIRECTORY

	fi

         #Do we allow the deletion of the old logs?
	 if [ $CLEARLOGDELETEALLOW -eq 1 ]
	 then
	    
            #Counts how many files are in the folder (For Script + Script Log)
            FILECOUNTDELETE=`find $CLEARLOGDELETEPATH$CLEARLOGDELETENAME -type f | wc -l`

            #Checks if file limit has been set to 1 for deleting the logs.
            if [ $CLEARLOGDELETEFILECOUNT -eq 1 ]
            then

               #Delete the old logs
               rm $CLEARLOGDELETEPATH$FILENAME

               #Check if the file is still in the folder
               if [ -f $FILENAME ]
               then

	          echo -e ${LANG_DELETEWASUNSUCCESSFUL}

	          #Do we allow logs Script logs?
	          if [ $LOGALLOW -eq 1 ]
	          then

	            #Writes file deletion date at the bottom of the Script log file
	            echo -e "\n${LANG_DELETEWASUNSUCCESSFUL}." >> "$LOGPATH""$LOGFILE"
	
	         fi

               else

                  echo -e ${LANG_DELETEWASSUCCESSFUL}

	          #Do we allow logs Script logs?
	          if [ $LOGALLOW -eq 1 ]
	          then

	            #Writes file deletion date at the bottom of the Script log file
	            echo -e "\n<"$FILEDATE"> '"$FILENAME"' ${LANG_CLEARDELETE2}." >> "$LOGPATH""$LOGFILE"
	
	          fi

            fi

            #Checks if the file number matches the file limit
            elif [ $FILECOUNTDELETE -eq $CLEARLOGDELETEFILECOUNT ]
            then

               for FILENAME in $CLEARLOGDELETEPATH$CLEARLOGDELETENAME
               do                  

                  #Deletes the just found log file
                  rm $FILENAME 
                  echo ${LANG_DELETEWASSUCCESSFUL}

                  if [ -f $FILENAME ]
                  then  

	             echo -e ${LANG_DELETEWASUNSUCCESSFUL}

	             #Do we allow Script Logs?
	             if [ $LOGALLOW -eq 1 ]
	             then

	               #Writes file deletion date at the bottom of the Script log file
	               echo -e "\n${LANG_DELETEWASUNSUCCESSFUL}." >> "$LOGPATH""$LOGFILE"
	
	            fi


                  else 

                     #Needless, since we write the same thing in the console above
                     #echo -e ${LANG_DELETEWASSUCCESSFUL}

	             #Do we allow Script logs?
	             if [ $LOGALLOW -eq 1 ]
	             then

	               #Writes file deletion date at the bottom of the Script log file
	               echo -e "\n<"$FILEDATE"> '"$FILENAME"' was ${LANG_CLEARDELETE2}." >> "$LOGPATH""$LOGFILE"
	
	             fi


                  fi

               done

            #Output, if he did nothing
            else

               echo -e ${LANG_DELETENOTHING}
	
            fi
	 fi



	#Do we allow Script logs?
	if [ $LOGALLOW -eq 1 ]
	then

	   #Write File Check Date at the very bottom of the Script log file
	   echo -e "\n<"$FILEDATE"> '"$FILENAME"' ${LANG_WASCLEARED}, ${LANG_FILENAME} was "$(displaytime $FILEAGE)" ${LANG_FILEAGE2}." >> "$LOGPATH""$LOGFILE"
	
           #Do we allow the old logs to be moved?
	   if [ $CLEARMOVEFILEALLOW -eq 1 ]
	   then

	      #Write file move date at the bottom of the Script log file
	      echo -e "\n<"$FILEDATE"> '"$FILENAME"' ${LANG_MOVEACTIVITY} $CLEARMOVEPATH$CLEARMOVEDIRECTORY ${LANG_MOVEACTIVITY2}." >> "$LOGPATH""$LOGFILE"
	
	   fi

	fi

   else

	#Console Output
	echo -e "<"$FILEDATE"> ${LANG_FILENAME} ${LANG_WASNOTCLEARED}, ${LANG_FILENAME} was "$(displaytime $FILEAGE)" "${LANG_FILEAGE2}".\n"

	#Do we allow Script logs
	if [ $LOGALLOW -eq 1 ]
	then
	
	   #Write File Check Date at the very bottom of the Script log file
	   echo -e "\n<"$FILEDATE"> '"$FILENAME"' ${LANG_CHECKFILEAGE}, ${LANG_FILENAME} was "$(displaytime $FILEAGE)" ${LANG_FILEAGE2}. - "$(displaytime $MAXAGE)" ${LANG_MAXAGE}." >> "$LOGPATH""$LOGFILE"
	
	fi

   fi
done