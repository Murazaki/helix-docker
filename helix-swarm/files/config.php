<?php
return array(
    'environment' => array(
        'hostname' => '%SWARMHOST%',
    ),
    'p4' => array(
        'port' => '%P4PORT%',
        'user' => '%SWARMUSER%',
        'password' => '%SWARMPASSWORD%',
    ),
    'mail' => array(
        'transport' => array(
            'host' => '%MAILHOST%',
        ),
    ),
    'security' => array(
        'require_login' => false, // defaults to true
    ),
);
