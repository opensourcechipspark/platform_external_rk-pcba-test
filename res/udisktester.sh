#!/sbin/sh

#RESULT_FILE="/data/udisk_capacity.txt"
#LOG_FILE="/data/udisk.log"
#source send_cmd_pipe.sh

#while true; do
    for nr in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
        udisk="/dev/block/sd$nr"
        udiskp=$udisk"1"
        part=$udisk
    
        #echo "searching disk ..." >> LOG_FILE
        while true; do
            while true; do
                if [ -b "$udisk" ]; then
                    busybox sleep 1
                    if [ -b "$udisk" ]; then
                        echo "udisk insert"
                        break;
                    fi
                else
                    busybox sleep 1
                fi
            done
            
            if [ ! -d "/tmp/udisk" ]; then
                busybox mkdir -p /tmp/udisk
            fi
            
            #echo "mounting disk ..." >> LOG_FILE
            busybox mount -t vfat $udisk /tmp/udisk
            if [ $? -ne 0 ]; then
                busybox mount -t vfat $udiskp /tmp/udisk
                if [ $? -ne 0 ]; then
                    echo "udisk mount failed" >> LOG_FILE
                    exit 1
                    #SEND_CMD_PIPE_FAIL $3
                    #busybox sleep 3
                    # goto for nr in ...
                    # detect next plugin, the devno will changed
                    #continue 2
                else
                    part=$udiskp
                fi
            fi
    
            break
        done
    
        capacity=`busybox df | toolbox grep /tmp/udisk | busybox awk '{printf $2}'`
        #echo "$part: $capacity" >> LOG_FILE

        busybox umount /tmp/udisk
        #SEND_CMD_PIPE_OK_EX $3 $capacity

        echo $capacity > /data/udisk_capacity.txt
        break
    
#        while true; do
#            if [ -b "$udisk" ]; then
#                echo "please remove udisk"
#                busybox sleep 1
#            else
#                echo "udisk removed"
#                break
#            fi
#        done
    done
#done

