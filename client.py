#!/bin/python3

import sys
sys.path.insert(0, "..")
import logging

from opcua import Client


if __name__ == "__main__":
    logging.basicConfig(level=logging.WARNING)
    client = Client("opc.tcp://localhost:4840/0")
    client.set_security_string("Basic256Sha256,SignAndEncrypt,./client.der,./client_key.pem")
    client.application_uri = "urn:FreeOpcUa:python-opcua"
    client.secure_channel_timeout = 10000
    client.session_timeout = 10000
    #client.set_user("paula")
    #client.set_password("paula123")
    try:
        client.connect()
        root = client.get_root_node()
        objects = client.get_objects_node()
        for child in objects.get_children():
            print("Child object at root: ", child)

    finally:
        client.disconnect()
