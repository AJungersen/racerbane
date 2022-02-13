import java.util.*;
//populationSize: Hvor mange "controllere" der genereres, controller = bil & hjerne & sensorer
int       populationSize  = 100;     

//CarSystem: Indholder en population af "controllere" 
CarSystem carSystem       = new CarSystem(populationSize);

//trackImage: RacerBanen , Vejen=sort, Udenfor=hvid, Målstreg= 100%grøn 
PImage    trackImage;

void setup() {
  size(500, 500);
  trackImage = loadImage("track.png");
}

void draw() {
  clear();
  background(255);
  fill(255);
  rect(0, 50, 1000, 1000);
  image(trackImage, 0, 0);  

  carSystem.updateAndDisplay();

  //TESTKODE: Frastortering af dårlige biler, for hver gang der går 200 frame - f.eks. dem der kører uden for banen
  /* if (frameCount%200==0) {
   println("FJERN DEM DER KØRER UDENFOR BANEN frameCount: " + frameCount);
   for (int i = carSystem.CarControllerList.size()-1 ; i >= 0;  i--) {
   SensorSystem s = carSystem.CarControllerList.get(i).sensorSystem;
   if(s.whiteSensorFrameCount > 0){
   carSystem.CarControllerList.remove(carSystem.CarControllerList.get(i));
   }
   }
   }*/
  //
}

void mouseClicked() {
  newGeneration(carSystem);
}






void newGeneration(CarSystem carSys) {
  int totalWhiteSpace = 0;
  for (int i = 0; i < carSys.CarControllerList.size(); i++) {
    totalWhiteSpace += carSys.CarControllerList.get(i).sensorSystem.whiteSensorFrameCount;
  }
  int aveWhiteSpace = totalWhiteSpace/carSys.CarControllerList.size();
  ArrayList<CarController> onTrackCarControllerList  = new ArrayList<CarController>();//liste over elementer, der kan videreavles på.
  for (int i = 0; i < carSys.CarControllerList.size(); i++) {
    if (carSys.CarControllerList.get(i).sensorSystem.whiteSensorFrameCount<aveWhiteSpace) {
      onTrackCarControllerList.add(carSys.CarControllerList.get(i));

      Comparator<CarController> sortCarControllerDescending = new Comparator<CarController>() {
        @Override 
          public int compare(CarController c1, CarController c2) {
          return (c2.sensorSystem.whiteSensorFrameCount < c1.sensorSystem.whiteSensorFrameCount ? -1 : (c2.sensorSystem.whiteSensorFrameCount == c1.sensorSystem.whiteSensorFrameCount) ? 0:1);
        }
      };
      Collections.sort(onTrackCarControllerList, sortCarControllerDescending);
      //println(onTrackCarControllerList.get(0).sensorSystem.whiteSensorFrameCount);
      //println(onTrackCarControllerList.get(onTrackCarControllerList.size()-1).sensorSystem.whiteSensorFrameCount);//giver mest optimale
    }
    

    //else{

    //carSys.CarControllerList.remove(carSys.CarControllerList.get(i));
    //}
  } for (int i = 0; i < carSys.CarControllerList.size(); i++) {
    carSys.CarControllerList.get(i).copyNeuNet(onTrackCarControllerList.get(onTrackCarControllerList.size()-1).hjerne);
    carSys.CarControllerList.get(i).bil = new Car();
    }
}
