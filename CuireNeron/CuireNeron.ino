/**
 *processing control a 2-4 servos platform 
 *modified by qq95538 
 *
 *my email address is 190808149@qq.com
 *
 */

 #include <CurieNeurons.h>
 CurieNeurons hNN;

 int catL = 0;
 int prevcat = 0;
 int dist, cat, nid, nsr, ncount;
 
 const short sampleNbr = 20;
 const short signalNbr = 2;
 byte vector[sampleNbr*signalNbr];
 byte flowX[sampleNbr];
 byte flowY[sampleNbr];
 boolean a = false;
 void setup()   
 {
   pinMode(13, OUTPUT);
   Serial.begin(115200);
   while (!Serial);
   if(hNN.begin()==0){
      Serial.print("neurons initialized");
      hNN.forget(500);
   }
   else{
      Serial.print("error.");
   }
 }
 void loop() 
 {
   while(Serial.available()==0);
   char data=Serial.read();
   for(int i = 0; i < sampleNbr; i++)
   {
       while(Serial.available()==0);
       vector[i*signalNbr]=Serial.read();
   }
   for(int i = 0; i < sampleNbr; i++)
   {
       while(Serial.available()==0);
       vector[i*signalNbr+1]=Serial.read();
   }
   a = !a;
   digitalWrite(13, a);   // turn the LED on (HIGH is the voltage level)
   switch(data)
   {    
       case '%':
           //learn 1
           catL = 1;          
           /*for(int i = 0; i <sampleNbr; i++){
              Serial.write(vector[i*signalNbr]); 
              Serial.write(vector[i*signalNbr+1]);
           }*/
           ncount = hNN.learn(vector, sampleNbr*signalNbr, catL);
           Serial.write(ncount);
           Serial.write("#");
           Serial.flush();
           break;
       case '^':
           //learn 1
           catL = 2;          
           /*for(int i = 0; i <sampleNbr; i++){
              Serial.write(vector[i*signalNbr]); 
              Serial.write(vector[i*signalNbr+1]);
           }*/
           ncount = hNN.learn(vector, sampleNbr*signalNbr, catL);
           Serial.write(ncount);
           Serial.write("#");
           Serial.flush();
           break;
       case '$':
           // Recognize
           hNN.classify(vector, sampleNbr*signalNbr,&dist, &cat, &nid);
           Serial.write(cat);
           Serial.write("#");
           Serial.flush();
           break;
                      
   }
   
 }

