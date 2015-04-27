from ThingSpeak import uploadData
from arduino_serial import ArduinoSerial
import csv

def main():
    connected = False
    while not (connected):
        try:
            inbound = ArduinoSerial()
        except (KeyboardInterrupt, SystemExit):
            raise
        except:
            print ("Error connecting to Arduino. Retrying...")
        else:
            connected = True
    while True:
        #message = (inbound.receiveMsg()).rstrip('\n')
        message = "1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9,10.10,11.11,12.12,13.13,14.14,15.15,16.16,17.17,18.18"
        splitMessage = message.split(",")
        try:
            data = map(float, message.split(","))
            if (len(data) == 18):
                success = 0
                while not (success == 1):
                    success = uploadData(data[:8], "H671BFO41N0TP246")
                success = 0
                while not (success == 1):
                    success = uploadData(data[8:16], "VJEFXKQ0AE4LD80D")
                success = 0
                while not (success == 1):
                    success = uploadData(data[16:18], "QPHVEZKYTKYNXOQZ")
        except ValueError:
            print ("value error")
if __name__ == "__main__":
    main()
