# open62541

This project builds the smallest dockerized implementation of the server_ctt
example with cryptography enabled

At the moment you 'have' to call server_ctt with --enableAnonymous as only user-name passwords are supported and non are set in the server_ctt example; which i found to be a bit of a red herring

## Prerequisits
You will need:
- Docker, and
- An internet connection for building the docker image

For running the supplied test app:
- Python3 (for running the test app)
- opcua (python module, i.e. `pip3 install opcua`)

## Getting Started
just call:
`
./start_open62541
`

This will
- Build the docker image with the name 'open62541'
- Create client certificates for the python script 'client-with-encryption.py'
- Copy the cert to the trusted folder
- Start the docker instance, and
- Run the python program
