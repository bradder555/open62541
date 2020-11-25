# open62541

This project builds the smallest dockerized implementation of the example server_ctt server with cryptography enabled

Useful for testing when you need a small, quick server with cryptography enabled

Much smaller than the official build (<10MB vs >200MB) this is because a two-step docker build process is used

The server does not authenticate clients (is run with --enableAnonymous flag)

You will need to mount the client certificate in the trusted folder, or 

If you are signing your clients with a CA, the CA certificate should go in the issuer folder

This repo is for building and testing locally as well as building the docker file, if you're interested in the docker file only, refer to the heading "Docker", otherwise refer to "Github"

## Docker
If you're interested in using the docker image only please use this section.

### Prerequisits 
You will need 
- docker,
- an OPC UA client, and 
- openssl (for generating certificates etc)

*Hint: refer to the github project for examples building the client certs*

### Getting Started
In order to connect to the server you will need to mount your CAs to issuers or client certs to trusted.

`/bin/sh
docker run -it -p 4840:4840 -v "$(pwd)/issuers/":/home/open62541/issuers/ -v "$(pwd)/trusted/":/home/open62541/trusted/ open62541
`

*Hint: the bash script start_open62541 in the github project gives an example of everything you need to get started*

## Github
For building and testing locally please refer to this section

### Prerequisits
You will need:
- Docker, and
- An internet connection for building the docker image

For running the supplied test app:
- Python3 (for running the test app)
- opcua (python module, i.e. `pip3 install opcua`)

### Getting Started
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
