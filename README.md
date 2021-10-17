# Helix Docker

Running a Perforce Server with Swarm.

Based on https://github.com/p4paul/helix-docker (BSD Perforce Copyright still applies)

## Build and Run

	docker-compose build
	docker-compose up
	
Swarm server runs on port [5080](http://localhost:5080).

Perforce server is on port 4000 and (replica on port 4001).

Perforce super user is `super` and password `Passw0rd`.

## Backup

Take a checkpoint (created in `data/helix-p4d/p4-home/checkpoints/`)

    p4 -C utf8  -p 4000 -u super admin checkpoint -Z
    
and then zip up the depots directory e.g.

    cd data/helix-p4d/p4-home/depots/
    tar cvfz depots.tar.gz *
    
Copy both the `data/helix-p4d/p4-home/depots/depots.tar.gz` and `data/helix-p4d/p4-home/checkpoints/master.ckp.*.gz ` to a safe location

## Restore

1. Create a symlink in the `data/helix-p4d/checkpoints/` directory called `latest` to the 'zipped' checkpoint you wish to restore.
2. Unzip the `depots.tar.gz` into the `data/helix-p4d/p4-home/depots/` directory
3. Restart docker compose.

Docker will look for a symlink called `latest` on startup and do the rest for you. 

## Cleanup

If things stop working try the following:

Simple cleanup script (intended for OS X) to remove unused docker images and volumes:

	docker-compose kill
	./clean.sh
	
Remove all image caches and start from fresh:

    docker-compose build --no-cache

