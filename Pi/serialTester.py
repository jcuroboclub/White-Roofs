__author__ = 'Atlaspud'

from arduino_serial import ArduinoSerial

serialInterface = ArduinoSerial()

msg = input("Enter message: ")
serialInterface.sendMsg(msg + "\n")
reMsg = serialInterface.receiveMsg()
print(reMsg)
