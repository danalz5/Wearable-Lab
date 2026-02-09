int buzzerPin = 11;

#include <Wire.h> // I2C Library
#include "SparkFun_Bio_Sensor_Hub_Library.h" // SparkFun Bio Sensor Hub Library

SparkFun_Bio_Sensor_Hub bioHub; // Create an object of the library

void setup() {
  pinMode(buzzerPin, OUTPUT); // Set the buzzer pin as an output
  intiializeBiohub();
}

void intiializeBiohub(){
  Serial.begin(115200); // Initialize serial communication
  Wire.begin(); // Initialize I2C communication

  // Initialize the sensor
  int result = bioHub.begin();
  if (result == 0) {
    Serial.println("Sensor started!");
  } else {
    Serial.println("Could not communicate with the sensor!");
  }

  // Configure sensor for BPM mode (Heart rate and SpO2)
  int error = bioHub.configBpm(MODE_ONE); 
  if (error == 0) {
    Serial.println("Sensor configured.");
  } else {
    Serial.println("Error configuring sensor.");
  }

  // Data lags a few seconds behind the sensor, add a delay to let the buffer fill
  Serial.println("Loading up the buffer with data....");
  delay(4000); 
}

void buzzerCode() {
  // Play a 1000 Hz tone for 1 second
  tone(buzzerPin, 1000);
  delay(1000);

  // Stop the tone
  noTone(buzzerPin);      
  delay(1000);
}

void biohub() {
  // Information from the readBpm function will be saved to the "body" variable
  bioData body = bioHub.readBpm();

  if (body.heartRate != 0) {
    // Print the data to the Serial Monitor
    Serial.print("Heartrate: ");
    Serial.println(body.heartRate);
    // Serial.print("Oxygen: ");
    // Serial.println(body.oxygen);
    // Serial.print("Confidence: ");
    // Serial.println(body.confidence);
    // Serial.print("Status: ");
    // Serial.println(body.status); // Status 0 indicates valid data
    // Serial.println("----------");
  }

  // Slowing down the loop
  delay(250); 
}

void loop() {
  // put your main code here, to run repeatedly:
  biohub();
}
