#===================================
#     CoDel parameters setup
#===================================
set Queue/CoDel interval_ 0.1
set Queue/CoDel target_ 0.005

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   200.0;              # time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Open the NS trace file
#set tracefile [open out.tr w]
#set q_f [open q_f.dat w]
#$ns trace-all $tracefile


#===================================
#        Nodes Definition        
#===================================
#Create 7 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n3 5.0Mb 10ms DropTail
$ns queue-limit $n0 $n3 50
$ns duplex-link $n1 $n3 5.0Mb 10ms DropTail
$ns queue-limit $n1 $n3 50
$ns duplex-link $n2 $n3 5.0Mb 10ms DropTail
$ns queue-limit $n2 $n3 50
$ns duplex-link $n3 $n4 0.5Mb 40ms CoDel
$ns queue-limit $n3 $n4 32
$ns duplex-link $n5 $n3 5.0Mb 10ms DropTail
$ns queue-limit $n5 $n3 50
$ns duplex-link $n6 $n3 5.0Mb 10ms DropTail
$ns queue-limit $n6 $n3 50

#===================================
#        Agents Definition        
#===================================
#Setup a TCP connections
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n4 $sink3
$ns connect $tcp0 $sink3
$tcp0 set packetSize_ 500

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink4 [new Agent/TCPSink]
$ns attach-agent $n4 $sink4
$ns connect $tcp1 $sink4
$tcp1 set packetSize_ 500

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
set sink5 [new Agent/TCPSink]
$ns attach-agent $n4 $sink5
$ns connect $tcp2 $sink5
$tcp2 set packetSize_ 500

set tcp6 [new Agent/TCP]
$ns attach-agent $n5 $tcp6
set sink8 [new Agent/TCPSink]
$ns attach-agent $n4 $sink8
$ns connect $tcp6 $sink8
$tcp6 set packetSize_ 500

set tcp7 [new Agent/TCP]
$ns attach-agent $n6 $tcp7
set sink9 [new Agent/TCPSink]
$ns attach-agent $n4 $sink9
$ns connect $tcp7 $sink9
$tcp7 set packetSize_ 500


#===================================
#        Applications Definition        
#===================================
#Setup a FTP Applications over TCP connections
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.0 "$ftp0 start"
$ns at 200.0 "$ftp0 stop"

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 1.0 "$ftp1 start"
$ns at 200.0 "$ftp1 stop"

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 1.0 "$ftp2 start"
$ns at 200.0 "$ftp2 stop"

set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp6
$ns at 1.0 "$ftp5 start"
$ns at 200.0 "$ftp5 stop"

set ftp6 [new Application/FTP]
$ftp6 attach-agent $tcp7
$ns at 1.0 "$ftp6 start"
$ns at 200.0 "$ftp6 stop"

# Tracing a queue
set codelq [[$ns link $n3 $n4] queue]
set tchan_ [open all.q w]
$codelq trace curq_
$codelq trace d_exp_
$codelq attach $tchan_


# Define 'finish' procedure (include post-simulation processes)
proc finish {} {
    global tchan_
    set awkCode {
	{
	    if ($1 == "Q" && NF>2) {
		print $2, $3 >> "temp.q";
		set end $2
	    }
	    else if ($1 == "a" && NF>2)
	    print $2, $3 >> "temp.a";
	}
    }
    set f [open temp.queue w]
    puts $f "TitleText: codel"
    puts $f "Device: Postscript"
    
    if { [info exists tchan_] } {
	close $tchan_
    }
    exec rm -f temp.q temp.a 
    exec touch temp.a temp.q
    
    exec awk $awkCode all.q
    
    puts $f \"queue
    exec cat temp.q >@ $f  
    puts $f \n\"d_exp_
    exec cat temp.a >@ $f
    close $f
    exec xgraph -bb -tk -x time -y queue temp.queue &
    exit 0
}

$ns at $val(stop)
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
