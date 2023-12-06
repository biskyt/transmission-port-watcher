# transmission-port-watcher
Watches a file and uses its contents to update the transmission peer port. Uses transmission-remote and inotify.

# usage
Mount a volume to `portforward` in the container. It must contain a file called `port.dat`, which contains a port number. See `thrnz/docker-wireguard-pia` for an example of how this file may get produced.

Takes the following environment variables:

| Variable   | Description |
|------------|-------------|
| TRHOST     | The host name of the transmission server (default is host.docker.internal) |
| TRPORT     | The port number that transmission is running on (default is 9091) |
| TRUSER     | The username for logging in to transmission |
| TRPASSWORD | The password for logging into transmission |