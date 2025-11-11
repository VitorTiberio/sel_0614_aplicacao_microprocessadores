#define LED 21
#define BUTTON 18
int var = false;

hw_timer_t *timer = NULL;

void ARDUINO_ISR_ATTR onTimer(){
  digitalWrite(LED, !digitalRead(LED));
}

void setup(){
  pinMode(LED, OUTPUT);
  pinMode(BUTTON, INPUT);
  timer = timerBegin(1000000);
  timerAttachInterrupt(timer, &onTimer);
  timerAlarm(timer, 1000000, true, 0);
  var = true;
}

void loop(){
  if (digitalRead(BUTTON) == HIGH && var){
    timerEnd(timer);
    digitalWrite(LED, LOW);
    var = false;
  } else if (digitalRead(BUTTON) == HIGH && !var){
    setup();
  }
}

