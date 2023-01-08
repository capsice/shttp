# SHTTP
SHTTP is a simple HTTP development server written in POSIX Shell.

## Installation
To install SHTTP, run `./install.sh`. To uninstall it, run `./install.sh clean`. It is important to ensure that the `.local/bin` directory (or equivalent) is included in your `$PATH` environment variable, as this is where the script will be installed and made available for execution.

### Dependencies
SHTTP depends on `socat` since I could not find a way to make `netcat` reliable for this application, mainly due to the wide amount of differences in functionality between implementations (GNU, BusyBox, OpenBSD, ...).

## Usage
To use SHTTP, run the `shttp` command with the following arguments:

+ `-p` specifies the port number that the server should listen on (8080 by default).
+ `-b` specifies the address or interface that the server should bind to (localhost by default).

For example, to start the server on port 8080 and bind it to all available network interfaces, you would run `shttp -p 8080 -b 0.0.0.0`.

Please note that the `shttp` command will start the local server in the current working directory.
