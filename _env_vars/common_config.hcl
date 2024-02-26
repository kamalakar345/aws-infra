locals{
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Common variable reference comming from common_config.hcl 
  region                                  = "us-west-2"
  admin_contact                           = "aware.cloud.eng.devops@quicinc.com"
  service_id                              = "AWARE"
  aws_account                             = 608026881676
  aware_services                          = ["analytic-processor", "aware_common", "aware-common-ui", "aware-core", "aware-mock-api", "aware-notification-engine", "aware-operational-portal-ui", "aware-public-ui", "aware-publicapi-documentation", "aware-rule-engine", "aware-service-dashboard-ui", "aware-session-manager", "builder-service", "coap-client", "coap-client-dtls", "coap-protocol-adaptor", "coap-protocol-adaptor-dtls", "command-service-aware", "docsapi", "feedback-service", "global-settings-service", "inclinometer-processor", "inclinometer-service", "location-service", "logstash-aware", "mockpublicapi", "msgdispatcher-pro-aware", "notification-service-aware", "nucleus_dm", "nucleus_dm-consumer", "nucleus_um", "playground-proxy", "profile-service-aware", "prom/blackbox-exporter", "public-ui", "route-config-api-aware", "rule-definition-service", "sensor-service-aware", "shadow-service", "shipment-processor", "swagger-common-ui", "telemetry-engine-aware", "telemetry-service-aware", "tenant-service-aware", "test-awarepublicapi", "tracker-service-aware", "tracker-shipment-service", "xns-service", "saga-um-global"]
# Glp-priv to Reg-priv Specific Configuration

## Reg private VPC Details
  reg_priv_vpc_id                         = "vpc-0d1e952fc353044a4"
  reg_priv_private_subnet_ids             = ["subnet-0424a3be9f4a2dcd1", "subnet-009826ec6d2eacddd"] //privateA and privateB

## Reg Public VPC Details

  reg_pub_vpc_id                          = "vpc-006fddfb83fd3d82f" // Public VPC-ID
  reg_pub_private_subnet_ids              = ["subnet-07ecc7b9ce267f52c", "subnet-0fa79d4c1a0b540fb"] //Public VPC-ID privateA and privateB

## Global Private VPC Details
  glb_priv_vpc_id                         = "vpc-0e12fd7cddf789df0"

  glb_priv_private_subnet_ids             = ["subnet-01361711531df36ea", "subnet-0d93f1226d98c1515"] //privateA and privateB

## Global Public VPC Details
  glb_pub_vpc_id                          = "vpc-0f92311d3fe6dadd0" // Public VPC-ID
  glb_pub_private_subnet_ids              = ["subnet-05e8d9167e0a807e8", "subnet-0d33f975ef183cd3f"] // [Public-privateA, Public-privateB]
}