@sdp = (
    {
        'category' => 'controller',
        'subcategory' => 'server+ctrl',
        'detail'   => 'server gets access data from ctrl',
        'function' => \&controller_cycle,
        # 'cmdline'  => $default_client_args_sdp,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str",
        # 'server_sending_spa' => 1,
        # 'fw_rule_created' => $NEW_RULE_REQUIRED,
        # 'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_positive_output_matches' => 
            [qr/All new credentials stored successfully/,
             qr/Succeeded in retrieving and installing service configuration/,
             qr/Succeeded in retrieving and installing access configuration/],
        'ctrl_positive_output_matches' => 
            [qr/New credentials successfully created/,
             qr/Successfully stored new keys/,
             qr/Received service data acknowledgement/,
             qr/Received access data acknowledgement/,
             qr/Found and removed SDP ID/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'all 3 components',
        'detail'   => 'add client to mix',
        'function' => \&controller_cycle,
        'cmdline'  => $default_client_args_sdp,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'no_ip_check' => 1,
        'wait_for_conn_close' => 1,
        'client_positive_output_matches' =>
            [qr/All new credentials stored successfully/],
        'server_positive_output_matches' => 
            [qr/Succeeded in retrieving and installing service configuration/,
             qr/Succeeded in retrieving and installing access configuration/,
             qr/Succeeded in modifying access data/,
             qr/ACCEPT.*?tcp dpt:80 \/\* _exp_\d{10} \*\//,
             qr/ACCEPT.*?tcp dpt:5000 \/\* _exp_\d{10} \*\//,
             qr/CONNMARK.*?tcp dpt:80 \/\* _exp_\d{10} \*\/ CONNMARK set 0x/,
             qr/CONNMARK.*?tcp dpt:5000 \/\* _exp_\d{10} \*\/ CONNMARK set 0x/,
             qr/New connections from SDP ID/,
             qr/connections closed for SDP ID/],
        'ctrl_positive_output_matches' => 
            [qr/New credentials successfully created/,
             qr/Successfully stored new keys/,
             qr/Received service data acknowledgement/,
             qr/Received access data acknowledgement/,
             qr/Successfully stored.*?connection data/,
             qr/Found and removed SDP ID/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'all 3 components',
        'detail'   => 'disable sdp id',
        'function' => \&controller_cycle,
        'cmdline'  => $default_client_args_sdp,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'no_ip_check' => 1,
        'disable_sdp_id' => 1,
        'client_positive_output_matches' =>
            [qr/All new credentials stored successfully/],
        'server_positive_output_matches' => 
            [qr/Succeeded in retrieving and installing service configuration/,
             qr/Succeeded in retrieving and installing access configuration/,
             qr/Succeeded in modifying access data/,
             qr/ACCEPT.*?tcp dpt:80 \/\* _exp_\d{10} \*\//,
             qr/ACCEPT.*?tcp dpt:5000 \/\* _exp_\d{10} \*\//,
             qr/CONNMARK.*?tcp dpt:80 \/\* _exp_\d{10} \*\/ CONNMARK set 0x/,
             qr/CONNMARK.*?tcp dpt:5000 \/\* _exp_\d{10} \*\/ CONNMARK set 0x/,
             qr/New connections from SDP ID/,
             qr/Gateway closed.*all.*connections from SDP ID/],
        'ctrl_positive_output_matches' => 
            [qr/New credentials successfully created/,
             qr/Successfully stored new keys/,
             qr/Received service data acknowledgement/,
             qr/Received access data acknowledgement/,
             qr/Successfully stored.*?connection data/,
             qr/Found and removed SDP ID/,
             qr/Sending access refresh to all connected gateways/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'all 3 components',
        'detail'   => 'remove service access',
        'function' => \&controller_cycle,
        'cmdline'  => $default_client_args_sdp,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'no_ip_check' => 1,
        'remove_service_access' => 1,
        'client_positive_output_matches' =>
            [qr/All new credentials stored successfully/],
        'server_positive_output_matches' => 
            [qr/Succeeded in retrieving and installing service configuration/,
             qr/Succeeded in retrieving and installing access configuration/,
             qr/Succeeded in modifying access data/,
             qr/ACCEPT.*?tcp dpt:80 \/\* _exp_\d{10} \*\//,
             qr/ACCEPT.*?tcp dpt:5000 \/\* _exp_\d{10} \*\//,
             qr/CONNMARK.*?tcp dpt:80 \/\* _exp_\d{10} \*\/ CONNMARK set 0x/,
             qr/CONNMARK.*?tcp dpt:5000 \/\* _exp_\d{10} \*\/ CONNMARK set 0x/,
             qr/New connections from SDP ID/,
             qr/Gateway closed the following invalid connection from SDP ID/],
        'ctrl_positive_output_matches' => 
            [qr/New credentials successfully created/,
             qr/Successfully stored new keys/,
             qr/Received service data acknowledgement/,
             qr/Received access data acknowledgement/,
             qr/Successfully stored.*?connection data/,
             qr/Found and removed SDP ID/,
             qr/Sending access refresh to all connected gateways/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'server config',
        'detail'   => 'bad ctrl client path',
        'function' => \&controller_cycle,
        'skip_controller' => 1,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str " .
            "--ctrl-client-conf ./bad/path/server_sdp_ctrl_client.conf",
        'server_exec_err' => 1,
        'server_positive_output_matches' => 
            [qr/Config file.*was not found/,
             qr/Failed to create new SDP ctrl client/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'server config',
        'detail'   => 'bad fwknoprc path',
        'function' => \&controller_cycle,
        'skip_controller' => 1,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str " .
            "--fwknop-client-conf ./bad/path/server.fwknoprc",
        'server_exec_err' => 1,
        'server_positive_output_matches' => 
            [qr/fwknoprc file.*was not found/,
             qr/Failed to create new SDP ctrl client/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'server config',
        'detail'   => 'min acc wait',
        'function' => \&controller_cycle,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str " .
            "--max-acc-wait 1",
        'server_exec_err_possible' => 1,
        'server_positive_output_matches' => 
            [qr/(Failed to get service and\/or access data from controller|Succeeded in retrieving and installing access configuration)/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'server config',
        'detail'   => 'zero acc wait',
        'function' => \&controller_cycle,
        'skip_controller' => 1,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str " .
            "--max-acc-wait 0",
        'server_exec_err' => 1,
        'server_positive_output_matches' => 
            [qr/var MAX_WAIT_ACC_DATA value.*not in the range/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'server config',
        'detail'   => 'acc wait too big',
        'function' => \&controller_cycle,
        'skip_controller' => 1,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str " .
            "--max-acc-wait 61",
        'server_exec_err' => 1,
        'server_positive_output_matches' => 
            [qr/var MAX_WAIT_ACC_DATA value.*not in the range/],
    },
    {
        'category' => 'controller',
        'subcategory' => 'client config',
        'detail'   => 'bad fwknop path', # service SPA will work, not controller SPA
        'function' => \&controller_cycle,
        'cmdline'  => $default_client_args_sdp,
        'client_ctrl_conf' => $cf{'client_ctrl_conf_bad_fwknop_path'},
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args_sdp $intf_str",
        'no_ip_check' => 1,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $REQUIRE_NO_NEW_REMOVED,
        'client_positive_output_matches' =>
            [qr/sdp_com.*Failed to send SPA/],
        'server_positive_output_matches' => 
            [qr/Succeeded in retrieving and installing service configuration/,
             qr/Succeeded in retrieving and installing access configuration/,
             qr/dpt:80/],   # this is the fw rule created if the gate gets the client spa for service access 
        'server_negative_output_matches' =>
            [qr/Succeeded in modifying access data/,
             qr/dpt:5000/],   # this is the fw rule created if the gate gets the client spa for controller access 
        'ctrl_positive_output_matches' => 
            [qr/New credentials successfully created/,
             qr/Successfully stored new keys/,
             qr/Received service data acknowledgement/,
             qr/Received access data acknowledgement/,
             qr/Found and removed SDP ID/],
    },
);