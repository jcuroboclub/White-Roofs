"""
"""
import serial

port = serial.Serial("/dev/ttyACM0", baudrate=115200, timeout=3.0)

while True:
    msg = input("\r\nSay Something: ")
    port.write("" + msg)
    rcv = port.read(10)
    print("" + rcv)
