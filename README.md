# Clearlog

TL:DR
An shell bash script, which checks the file age of logs and overwrites them, moves them and deletes them.

# What is Clearlog?

Clearlog is a bash Script, that checks the age of a file. When it exceeds the time limit, the file contents will be overwritten with a timestamp it was overwritten and how old the file was. 

Clearlog also logs everything it does in the console and when you allow it, in an extra clearlog.log (customizable) file.
For instance, when you run clearlog and the file did not hit the time limit, an timestamp, the fileage and the maximum file age will be written at the bottom of the log file.

You also can allow that overwritten logs will be moved into another directory, you can define the move path and the directory name.

And last but not least, you can allow to delete the log files inside the "move directory".
You can specify the file limit when the files inside the direcotry gets deleted, but when you type in 0, they instantly will be removed.

# In Summary

- It overwrites the content of a file to make it unusable
- It moves edited log files into another direcotry
- It deletes those logs inside the move directory
- It logs everything it does
- It has cool ascii art

# Why did I create ClearLog?

Because the EU made the "General Data Protection Regulation" or GDPR, we have to handle files with sensitive information like IP adresses more carefully and delete log files every few months. I originally made it to learn and to understand shell / bash and because im not the only one that needs to follow the GDPR, I've made it public and have tested it extensively to ensure it works the way it was intended.

# How can I use Clearlog?

Just edit the clearlog.config to your likings, set up the paths to the log files, set up the maximum file age and create a cronjob that starts the clearlog.sh at the beginning of every month.

When you have problems or run into a problem, please dont hesitate to contact me! 

# How can I help Clearlog?

Because im nowhere near a professional shell scripter or a native english speaker and you know ways to shorten my script up or fix my broken english, just leave a message and we talk about everything. Or open an issue here.

- Message me on Steam: https://steamcommunity.com/id/deadalus3010 
(Maybe first write in the comments why you add me, just to inform me)
- Join my Teamspeak: ts.platincore.de
- Add me on Discord: Deadalus | #5692

# Credits

Without those 2 functions this wouldnt be possible

comparedate() from ashrithr:
https://gist.github.com/ashrithr/5614283

displaytime() from Stéphane Gimenez:
https://unix.stackexchange.com/users/9426/st%c3%a9phane-gimenez
https://unix.stackexchange.com/questions/27013/displaying-seconds-as-days-hours-mins-seconds
