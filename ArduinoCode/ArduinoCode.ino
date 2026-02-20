int buzzerPin = 12;

#include <Wire.h> // I2C Library
#include "SparkFun_Bio_Sensor_Hub_Library.h" // SparkFun Bio Sensor Hub Library

//Biohub varaibles
SparkFun_Bio_Sensor_Hub bioHub; // Create an object of the library
unsigned long lastBioHubCheck = 0;
const int BIOHUB_INTERVAL = 250;

//Buzzer variables
bool buzzerOn = false;
unsigned long lastBuzzerCheck = 0;
const int BUZZER_INTERVAL1 = 1000;
const int BUZZER_INTERVAL2 = 2000;

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
  if (!buzzerOn){
    noTone(buzzerPin);
    return;
  }

  unsigned long currentMillis = millis();

  if (currentMillis - lastBuzzerCheck < 1000) {
    tone(buzzerPin, 1000);
  }
  else if (currentMillis - lastBuzzerCheck < 2000) {
    noTone(buzzerPin);
  }
  else {
    buzzerOn = false;
    lastBuzzerCheck = currentMillis;
  }
}

void biohub() {
  if (millis() - lastBioHubCheck >= BIOHUB_INTERVAL){
    lastBioHubCheck = millis();
    // Information from the readBpm function will be saved to the "body" variable
    bioData body = bioHub.readBpm();

    if (body.heartRate != 0) {
      // Print the data to the Serial Monitor
      // Serial.print("Heartrate: ");
      Serial.println("HR:" + String(body.heartRate));
      // Serial.print("Oxygen: ");
      // Serial.println(body.oxygen);
      // Serial.print("Confidence: ");
      // Serial.println(body.confidence);
      // Serial.print("Status: ");
      // Serial.println(body.status); // Status 0 indicates valid data
      // Serial.println("----------");
    }
  }
}

void recieverCode() {
  // RECEIVE: Check for age from Processing
  if (Serial.available() > 0) {
    String data = Serial.readStringUntil('\n');
    data.trim();

    if (data.length() == 0) return;

    Serial.print("Raw received: [");
    Serial.print(data);
    Serial.print("] Length: ");
    Serial.print(data.length());
    Serial.print("Is index found: ");
    Serial.println(data.indexOf("S"));
    Serial.println(buzzerOn);
    
    if (data.indexOf("S") >= 0 && !buzzerOn) {
      Serial.println("STRESS detected - turning on buzzer");
      buzzerOn = true;
    }
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  biohub();
  buzzerCode();
  recieverCode();
}
