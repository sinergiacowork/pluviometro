// 1 tip ~ 0.3 mm

#define LED D7
#define rainGuagePin D0

char rainFall[10];

volatile unsigned long rainEvents = 0;
volatile unsigned long nextRainEvent = 0;

void rainGuageEvent() {
    unsigned long m = millis();
    if (m > nextRainEvent) {
        rainEvents++;
        nextRainEvent = m + 10;
    }
}

void setup() {
    Serial.begin(38400);
    Serial.println("Up and running!");

    pinMode(LED, OUTPUT);
    pinMode(rainGuagePin, INPUT_PULLDOWN);

    attachInterrupt(rainGuagePin, rainGuageEvent, CHANGE);

    Spark.variable("rain", &rainFall, STRING);
}

void loop() {
    digitalWrite(LED, LOW);
    sprintf(rainFall, "%ld", rainEvents);
}
