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
    // this block should be a peer of 'p4'
    'redis' => array(
        'options' => array(
            'password' => '%REDISPASSWORD%',
            'namespace' => 'swarm',
            'server' => array(
                'host' => 'redis.helix',
                'port' => '6379',
            ),
        ),
        'items_batch_size' => 100000,
        'check_integrity' => '04:00', // Defaults to '03:00' Use one of the following two formats: 
                                      // 1) The time of day that the integrity check starts each day. Set in 24 hour format with leading zeros and a : separator
                                      // 2) The number of seconds between each integrity check. Set as a positive integer. Specify '0' to disable the integrity check.
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
