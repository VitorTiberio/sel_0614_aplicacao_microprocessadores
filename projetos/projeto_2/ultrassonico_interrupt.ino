// Projeto 02 - SEL0614 - Aplicação de Microprocessadores // 
// Prof. Ricardo Augusto de Souza Fernandes - EESC/USP //
// Aluno: Caio Florentin de Oliveira - - Eng. Computação // 
// Aluno: Vitor Augusto Tibério - 14658834 - Eng. Elétrica // 

// Definindo os pinos // 

# define ECHO 18
# define TRIGGER 5
# define LED 21

// Varaiáveis Globais // 

volatile bool deveChecarDistancia = false; // cria uma variável booleana volátil
hw_timer_t *timer = NULL; //cria o timer 

void ARDUINO_ISR_ATTR onTimer(){
  deveChecarDistancia = true;
}

void setup() {
  Serial.begin(115200);
  pinMode(TRIGGER, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(LED, OUTPUT);
  timer = timerBegin(500000);
  timerAttachInterrupt(timer, &onTimer);
  timerAlarm(timer, 500000, true, 0);

}

void loop() {
  if (deveChecarDistancia){
    deveChecarDistancia = false; 
    // Gera o pulso do ultrassônico //
    digitalWrite(TRIGGER, LOW);
    delayMicroseconds(2);
    digitalWrite(TRIGGER, HIGH);
    delayMicroseconds(10); 
    digitalWrite(TRIGGER, LOW);
    // Calcula a distância // 
    long duration = pulseIn(ECHO, HIGH);
    float distanceCm = duration * 0.0343 / 2.0;
    // Mostra na Serial // 
    Serial.print("Distancia: ");
    Serial.print(distanceCm);
    Serial.println(" cm");
    if (distanceCm > 0 && distanceCm < 150){
      digitalWrite(LED, HIGH);
    } else {
      digitalWrite(LED, LOW);
    }
  }
}
