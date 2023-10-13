locals{
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Common variable reference comming from common_config.hcl 
  region                                  = "us-west-2"
  admin_contact                           = "aware.cloud.eng.devops@quicinc.com"
  service_id                              = "AWARE"
  aws_account                             = 098222969212
  aware_services                          = ["analytic-processor", "aware_common", "aware-common-ui", "aware-core", "aware-mock-api", "aware-notification-engine", "aware-operational-portal-ui", "aware-public-ui", "aware-publicapi-documentation", "aware-rule-engine", "aware-service-dashboard-ui", "aware-session-manager", "builder-service", "coap-client", "coap-client-dtls", "coap-protocol-adaptor", "coap-protocol-adaptor-dtls", "command-service-aware", "docsapi", "feedback-service", "global-settings-service", "inclinometer-processor", "inclinometer-service", "location-service", "logstash-aware", "mockpublicapi", "msgdispatcher-pro-aware", "notification-service-aware", "nucleus_dm", "nucleus_dm-consumer", "nucleus_um", "playground-proxy", "profile-service-aware", "prom/blackbox-exporter", "public-ui", "route-config-api-aware", "rule-definition-service", "sensor-service-aware", "shadow-service", "shipment-processor", "swagger-common-ui", "telemetry-engine-aware", "telemetry-service-aware", "tenant-service-aware", "test-awarepublicapi", "tracker-service-aware", "tracker-shipment-service", "xns-service"]
# Glp-priv to Reg-priv Specific Configuration

## Reg private VPC Details
  reg_priv_vpc_id                         = "vpc-06b5a0014044ee4aa"
  reg_priv_private_subnet_ids             = ["subnet-09aa3a9354da74d9c", "subnet-00ab87025981519d4"] //privateA and privateB

## Reg Public VPC Details

  reg_pub_vpc_id                          = "vpc-09ee7634b8fcfc251" // Public VPC-ID
  reg_pub_private_subnet_ids              = ["subnet-0b1812b1bb3be4c75", "subnet-0d2d487515ababff7"] //Public VPC-ID privateA and privateB

## Global Private VPC Details
  glb_priv_vpc_id                         = "vpc-0aaaef5076cc6ff75"

  glb_priv_private_subnet_ids             = ["subnet-06c40b52f1e99cfd2", "subnet-09619c9c6693d2bf8"] //privateA and privateB

## Global Public VPC Details
  glb_pub_vpc_id                          = "vpc-073355ca2b946aa10" // Public VPC-ID
  glb_pub_private_subnet_ids              = ["subnet-0b87894020d4d723c", "subnet-019043f82688bcba4"] // [Public-privateA, Public-privateB]
}