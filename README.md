# transmission-port-watcher
Watches a file and uses its contents to update the transmission peer port. Uses transmission-remote and inotify.

# usage
Mount a volume to `portforward` in the container. It must contain a file called `port.dat`, which contains a port number. See `thrnz/docker-wireguard-pia` for an example of how this file may get produced.

The filename can be overridden using the `PORTFILENAME` env var if necessary - see below.

Takes the following environment variables:

| Variable   | Description |
|------------|-------------|
| `PORTFILENAME` | The filename in the portforward volume to monitor for changes (default port.dat) |
| `TRHOST`     | The host name of the transmission server (default is host.docker.internal) |
| `TRPASSWORD` | The password for logging into transmission |
| `TRPORT`     | The port number that transmission is running on (default is 9091) |
| `TRUSER`     | The username for logging in to transmission |
