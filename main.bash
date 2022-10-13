
#Creat new directory for cache and output files
mkdir web_monitor_log
cd web_monitor_log
touch internetlogg.txt  #cut .csv space catch file
touch netk.txt  # network usage catch file
touch withnoaddress.csv # cut .csv space csv file
touch withspace.csv # .csv file with space format
touch withspace.txt # .txt file with space format
touch netlog.txt #Full imformation log file
touch Finallog.txt # Save all information .txt catch file
touch Finallogshort.txt # Save useful information .txt file
touch Finalwithsapce.txt # delete space format
touch Finallogdone.csv # Web usage information
touch Finallogtranstart.csv # Package count since start catch file
touch Finallogtranend.csv # Package count after transfer catch file

touch WebLogg.csv #Final log


# Meaning of parameters 
echo "Active Internet connections (w/o servers)" >>netlog.txt
echo "Protocal Reveive-Queue Send-Queue LocalIPAddress ForeignIPAddress State PID" >>netlog.txt
echo "Iface/Interface MTU/StandsforMaximumTransmissionUnit RX-ok/Packagegot RX-ERR/Packageerror RX-DRP/Packagedrope RX-OVR/Packageoverwrite TX-OK/meanssendpackage TX-ERROR/SendError TX-DRP/SendDrop TX-OVR/Sendoverwrite FLG/BROADCASTflag"  >>netlog.txt
      
# Ignore useless informations
      while :
      do
      netstat -t -p | sed -n '2,3p'  >catch.txt
      awk '{print NR}' catch.txt|tail -n1  >number.txt 

      read number <number.txt
if [ "$number" = "1" ]; then
  echo "no process"
else
      ifconfig -s > Finallogtranstart.csv
      netstat -t -p | sed -n '2,3p'  >> netlog.txt
      netstat -t -p | sed -n '2,3p'  >> Finallog.txt
      ifconfig -s > Finallogtranend.csv

#  1s Sleep time, time can be changed as any time you wish 
      sleep 1s 
fi   

#  1s Sleep time, time can be changed as any time you wish 
      sleep 1s 
      ifconfig -s >> netlog.txt

# Ready to make .csv output      

       sed 's/Address//g' netlog.txt > netK.txt
       sed 's/Address//g' Finallog.txt > Finallogshort.txt
      
       sed -e 's/[[:space:]][[:space:]]*/ /g' Finallogtranstart.csv > Finallogtranstart1.csv
       sed -e 's/[[:space:]][[:space:]]*/ /g' Finallogtranend.csv > Finallogtranend1.csv
       sed -e 's/[[:space:]][[:space:]]*/ /g' netK.txt > withspace.csv

       sed -e 's/[[:space:]][[:space:]]*/ /g' Finallogshort.txt > Finalwithsapce.csv

       sed -e 's/[[:space:]][[:space:]]*/ /g' netK.txt > withspace.txt

       cat netK.txt | sed -e 's/[[:space:]][[:space:]]*/ /g'  > withspace.csv
       cat netK.txt | sed -e 's/[[:space:]][[:space:]]*/ /g'  > withspace.txt

       sed -i 's/\s\+/,/g' Finallogtranstart1.csv
        sed -i 's/\s\+/,/g' Finallogtranend1.csv
       sed -i 's/\s\+/,/g' withspace.csv
       sed -i 's/\s\+/,/g' withspace.txt

       sed -i 's/\s\+/,/g' Finalwithsapce.csv

      cat withspace.csv > internetlogg.csv 
      cat withspace.txt > internetlogg.txt 
      cat Finalwithsapce.csv > Finallogdone.csv
      
      cat Finallogtranstart1.csv > WebLog.csv
      awk -F '|' '!x[$1,$2,$3,$4]++' Finallogdone.csv >> filename_dedup.csv
      cat filename_dedup.csv |  awk -F '|' '!x[$1,$4,$5,$7]++' >> WebLog.csv
      cat Finallogtranend1.csv |  awk -F '|' '!x[$1,$2,$3,$4]++'  >> WebLog.csv
      cat WebLog.csv | awk -F"[,]+" '{print $1,$3,$4,$5,$7}' > WebLogg.csv
      sed -i 's/\s\+/,/g' WebLogg.csv
     done
 
