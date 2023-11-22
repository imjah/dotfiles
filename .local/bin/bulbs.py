#!/usr/bin/python3

import os
import sys
import requests

def get(path):
    response = requests.get(f"{BASE_URL}{path}")

    if response.status_code != 200:
        sys.exit(f"Error {response.status_code}")

    return response.text

def put(path):
    response = requests.put(f"{BASE_URL}{path}")

    if response.status_code != 200:
        sys.exit(f"Error {response.status_code}")

def is_led_on():
    return get("/led/on").find("1") != -1

def parse_light(l):
    if l[0] in ["+", "-"]:
        try:
            l = float(get("/led/brightness")[15:-3]) * 100 + float(l)
        except TypeError as e:
            sys.exit("Invalid light value")

    return (float(l) / 100) % 1

try:
    BASE_URL = f"http://{os.environ['BULBS_IP']}"
except KeyError as e:
    sys.exit("BULBS_IP not found")

try:
    match sys.argv[1]:
        case "-s":
            print(get("/led")[:-1])
        case "-c":
            put(f"/led/color/{sys.argv[2]}")
        case "-l":
            put(f"/led/brightness/{parse_light(sys.argv[2])}")
        case "-o":
            put("/led/on")
        case "-f":
            put("/led/off")
        case "-t":
            put(f"/led/{'off' if is_led_on() else 'on'}")
except IndexError as e:
    print(
       f"Usage: {os.path.basename(sys.argv[0])} <option> [value]",
        "",
        "Options:",
        "-s  Show status",
        "-c  Set color",
        "-l  Set light intensity",
        "-o  Turn on the light",
        "-f  Turn off the light",
        "-t  Toggle the light",
        sep="\n"
    )
