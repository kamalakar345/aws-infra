locals{
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Common variable reference comming from common_config.hcl 
  region                                  = "us-west-2"
  admin_contact                           = "aware.cloud.eng.devops@quicinc.com"
  service_id                              = "AWARE"
  aws_account                             = 607644472201
  aware_services                          = ["analytic-processor", "aware-common-ui", "aware-notification-alert-engine", "aware-notification-webhook-engine", "aware-operational-portal-ui", "aware-rnd-mockapi", "aware-rnd-mockapi-proxy", "aware-rnd-playground-proxy_catalogue", "aware-rnd-proxy", "aware-rnd-translation", "aware-rule-engine", "aware-service-dashboard-ui", "aware-session-manager", "coap-client-dtls", "coap-protocol-adaptor-dtls", "command-service-aware", "dm_global_private", "dm_regional_private", "dmconsumer_global_private", "dmconsumer_regional_private", "feedback-service", "global-settings-service", "inclinometer-processor", "inclinometer-service", "location-service", "msgdispatcher-pro-aware", "notification-persistence-service", "notification-service-aware", "playgroundproxy-test-publicapi", "profile-service-aware", "route-config-api-aware", "rule-definition-service", "saga_um_global_pvt", "saga_um_regional_pvt", "sensor-service-aware", "shadow-service", "shipment-processor", "storage-service", "swagger-common-ui", "telemetry-engine-aware", "telemetry-service-aware", "tenant-service-aware", "tracker-service-aware", "tracker-shipment-service", "xns-service"]
# Glp-priv to Reg-priv Specific Configuration

## Reg private VPC Details
  reg_priv_vpc_id                         = "vpc-0f4a759403cf33bb1"
  reg_priv_private_subnet_ids             = ["subnet-0a2a50f785da5a0b1", "subnet-0586625bbae0f5683", "subnet-0c7026c5f8425e030"] //privateA and privateB and privateC

## Reg Public VPC Details

  reg_pub_vpc_id                          = "vpc-0c6d1887dcc478750" // Public VPC-ID
  reg_pub_private_subnet_ids              = ["subnet-0f33779d4b8828a68", "subnet-026adba5c45fdb754", "subnet-0c0a6145cf0a2600e"]//Public VPC-ID privateA and privateB and privateC

## Global Private VPC Details
  glb_priv_vpc_id                         = "vpc-0adff9db11bb6aee0"
  glb_priv_private_subnet_ids             = ["subnet-0e30a22a1b92cfc6c", "subnet-0e9d6eb45f0c074c3", "subnet-05332e16c5782142a"] //privateA and privateB and privateC

## Global Public VPC Details
  glb_pub_vpc_id                          = "vpc-0081cf4a7b9561843" // Public VPC-ID
  glb_pub_private_subnet_ids              = ["subnet-0b1b662b5e5e0598a", "subnet-01402984a57e38df9", "subnet-0c2fdc9381feac90a"] // [Public-privateA, Public-privateB, Public-privateC]

## quicksite Details
   quicksight_enabled                     = true
   admin_user                             = ["choudha@qti.qualcomm.com", "aygu@qti.qualcomm.com", "kmalugul@quicinc.com"]
   quicksight_email                       = "choudha@qti.qualcomm.com"
   start_time                             = "2024-02-02T12:30:35"
  
}
