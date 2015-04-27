"""
"""
import serial

class ArduinoSerial:
    def __init__(self):
        self.port = serial.Serial("/dev/ttyACM0", baudrate=115200, timeout=3.0)

    def __str__(self):
        return "swag"

    def sendMsg(self, message):
        self.port.write("" + message)

    def receiveMsg(self):
        return self.port.readline()

