/* Include the controller definition */
#include "epuck_test_lightsensors.h"
/* Function definitions for XML parsing */
#include <argos3/core/utility/configuration/argos_configuration.h>

/****************************************/
/****************************************/

CEPuckTestlight::CEPuckTestlight() :
   m_pcWheels(NULL),
   m_pcProximity(NULL),
   m_pcBaseLeds(NULL),
   m_pcLightSensors(NULL),
   m_fWheelVelocity(2.5f)
       {}

/****************************************/
/****************************************/

void CEPuckTestlight::Init(TConfigurationNode& t_node) {
   /*
    * Get sensor/actuator handles
    *
    * The passed string (ex. "differential_steering") corresponds to the
    * XML tag of the device whose handle we want to have. For a list of
    * allowed values, type at the command prompt:
    *
    * $ argos3 -q actuators
    *
    * to have a list of all the possible actuators, or
    *
    * $ argos3 -q sensors
    *
    * to have a list of all the possible sensors.
    *
    * NOTE: ARGoS creates and initializes actuators and sensors
    * internally, on the basis of the lists provided the configuration
    * file at the <controllers><epuck_obstacleavoidance><actuators> and
    * <controllers><epuck_obstacleavoidance><sensors> sections. If you forgot to
    * list a device in the XML and then you request it here, an error
    * occurs.
    */
   m_pcWheels = GetActuator<CCI_EPuckWheelsActuator>("epuck_wheels");
   m_pcBaseLeds = GetActuator<CCI_EPuckBaseLEDsActuator>("epuck_base_leds");

   m_pcProximity = GetSensor<CCI_EPuckProximitySensor>("epuck_proximity");
   m_pcLightSensors = GetSensor<CCI_EPuckLightSensor>("epuck_light");
   m_pcGroundSensor = GetSensor<CCI_EPuckGroundSensor>("epuck_ground");

   //m_pcRng = CRandom::CreateRNG("argos");

   /*
    * Parse the configuration file
    *
    * The user defines this part. Here, the algorithm accepts three
    * parameters and it's nice to put them in the config file so we don't
    * have to recompile if we want to try other settings.
    */
   GetNodeAttributeOrDefault(t_node, "velocity", m_fWheelVelocity, m_fWheelVelocity);
}

/****************************************/
/****************************************/

void CEPuckTestlight::ControlStep() {
   /* Get the highest reading in front of the robot, which corresponds to the closest object */
   Real fMaxReadVal = m_pcProximity->GetReadings()[0].Value;
   UInt32 unMaxReadIdx = 0;
   if(fMaxReadVal < m_pcProximity->GetReadings()[1].Value) {
      fMaxReadVal = m_pcProximity->GetReadings()[1].Value;
      unMaxReadIdx = 1;
   }
   if(fMaxReadVal < m_pcProximity->GetReadings()[7].Value) {
      fMaxReadVal = m_pcProximity->GetReadings()[7].Value;
      unMaxReadIdx = 7;
   }
   if(fMaxReadVal < m_pcProximity->GetReadings()[6].Value) {
      fMaxReadVal = m_pcProximity->GetReadings()[6].Value;
      unMaxReadIdx = 6;
   }
   /* Do we have an obstacle in front? */
   if(fMaxReadVal > 0.0f) {
     /* Yes, we do: avoid it */
     if(unMaxReadIdx == 0 || unMaxReadIdx == 1) {
       /* The obstacle is on the left, turn right */
       m_pcWheels->SetLinearVelocity(m_fWheelVelocity, 0.0f);
     }
     else {
       /* The obstacle is on the left, turn right */
       m_pcWheels->SetLinearVelocity(0.0f, m_fWheelVelocity);
     }
   }
   else {
     /* No, we don't: go straight */
      m_pcWheels->SetLinearVelocity(m_fWheelVelocity, m_fWheelVelocity);
   }

   for (int i=0;i<8;i++)
   {
       //std::cout << m_pcLightSensors->GetReadings()[i].Value << std::endl;
       if (m_pcLightSensors->GetReadings()[i].Value > 0.5)
       {
           m_pcBaseLeds->SwitchLED(i,true);
       }
       else
       {
           m_pcBaseLeds->SwitchLED(i,false);
       }
   }

   if (m_pcGroundSensor != NULL) {
     const CCI_EPuckGroundSensor::SReadings& readings = m_pcGroundSensor->GetReadings();
     LOG << readings.Left << "::" << readings.Center << "::" << readings.Right << std::endl;
   }


   // Real decision;
   // decision = m_pcRng->Uniform(CRange<UInt32>(0,2));
   // if (decision == 2) {
   //   LOG<< "DECISION=2 !!! :" << decision << std::endl;
   // }


}

/****************************************/
/****************************************/

/*
 * This statement notifies ARGoS of the existence of the controller.
 * It binds the class passed as first argument to the string passed as
 * second argument.
 * The string is then usable in the configuration file to refer to this
 * controller.
 * When ARGoS reads that string in the configuration file, it knows which
 * controller class to instantiate.
 * See also the configuration files for an example of how this is used.
 */
REGISTER_CONTROLLER(CEPuckTestlight, "epuck_test_lightsensors")
