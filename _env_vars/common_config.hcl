locals{
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Common variable reference comming from common_config.hcl 
  region                                  = "us-west-2"
  admin_contact                           = "aware.cloud.eng.devops@quicinc.com"
  service_id                              = "AWARE"
  aws_account                             = 521673828050
  aware_services                          = ["analytic-processor", "aware-common-ui", "aware-notification-alert-engine", "aware-notification-webhook-engine", "aware-operational-portal-ui", "aware-rnd-mockapi", "aware-rnd-mockapi-proxy", "aware-rnd-playground-proxy_catalogue", "aware-rnd-proxy", "aware-rnd-translation", "aware-rule-engine", "aware-service-dashboard-ui", "aware-session-manager", "coap-client-dtls", "coap-protocol-adaptor-dtls", "command-service-aware", "dm_global_private", "dm_regional_private", "dmconsumer_global_private", "dmconsumer_regional_private", "feedback-service", "global-settings-service", "inclinometer-processor", "inclinometer-service", "location-service", "msgdispatcher-pro-aware", "notification-persistence-service", "notification-service-aware", "playgroundproxy-test-publicapi", "profile-service-aware", "route-config-api-aware", "rule-definition-service", "saga_um_global_pvt", "saga_um_regional_pvt", "sensor-service-aware", "shadow-service", "shipment-processor", "storage-service", "swagger-common-ui", "telemetry-engine-aware", "telemetry-service-aware", "tenant-service-aware", "tracker-service-aware", "tracker-shipment-service", "xns-service"]
# Glp-priv to Reg-priv Specific Configuration

## Reg private VPC Details
  reg_priv_vpc_id                         = "vpc-0084581b793982642"
  reg_priv_private_subnet_ids             = ["subnet-0ec0bea2b55682148", "subnet-010e90bafe170d2c9"] //privateA and privateB

## Reg Public VPC Details

  reg_pub_vpc_id                          = "vpc-0f07b492c52e2a1c2" // Public VPC-ID
  reg_pub_private_subnet_ids              = ["subnet-0d4cfde020b233610", "subnet-000a49a802c271e8b"]//Public VPC-ID privateA and privateB

## Global Private VPC Details
  glb_priv_vpc_id                         = "vpc-04d592619ab4426b8"
  glb_priv_private_subnet_ids             = ["subnet-0c26a3a6ca43e6c5f", "subnet-0867a354e15281b76"] //privateA and privateB

## Global Public VPC Details
  glb_pub_vpc_id                          = "vpc-0cfc23d53dd0bc3ee" // Public VPC-ID
  glb_pub_private_subnet_ids              = ["subnet-06c6d9a88cde1f9fb", "subnet-0c2e2ed2f3f633297"] // [Public-privateA, Public-privateB]
}