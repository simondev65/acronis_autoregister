$wait=true
while ($wait){
    $tcp=get-nettcpconnection -State Listen -LocalPort 43234
    if ($tcp.state!="Listen"){
        
        write-output "waiting for acronis to start"
        sleep 5
    }else{
        $wait=false
        write-output "acronis started, continuing job"

    }
    }
}

