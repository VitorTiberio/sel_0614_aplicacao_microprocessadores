// Projeto 02 - SEL0614 - Aplicação de Microprocessadores // 
// Prof. Ricardo Augusto de Souza Fernandes - EESC/USP //
// Aluno: Caio Florentin de Oliveira - - Eng. Computação // 
// Aluno: Vitor Augusto Tibério - 14658834 - Eng. Elétrica // 

// Definindo os pinos // 

# define ECHO 18
# define TRIGGER 5
# define LED 21

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(TRIGGER, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(LED, OUTPUT);


}

void loop() {
  // Gera o pulso do ultrassônico //
  digitalWrite(TRIGGER, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIGGER, HIGH);
  delayMicroseconds(10); // Pulso de 10 microssegundos
  digitalWrite(TRIGGER, LOW);
  // Calcula a distância do ultrassônico //
  long duration = pulseIn(ECHO, HIGH);
  float distanceCm = duration * 0.0343 / 2.0;
  // Lê (serialmente) a leitura do sensor //
  Serial.print("Distancia: ");
  Serial.print(distanceCm);
  Serial.println(" cm");
  delay(500);
}
