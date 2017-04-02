void setup()
{
  Serial.begin(9600);
  Serial.println("uBlox Neo 6M Test");
  Serial1.begin(9600);
}

void loop() // run over and over
{
  if (Serial1.available())
     Serial.write(Serial1.read());
}
