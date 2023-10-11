locals{
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Common variable reference comming from common_config.hcl 
  region                                  = "us-west-2"
  admin_contact                           = "aware.cloud.eng.devops@quicinc.com"
  service_id                              = "AWARE"
  aws_account                             = 914410644643
  aware_services                          = ["analytic-processor", "aware_common", "aware-common-ui", "aware-core", "aware-mock-api", "aware-notification-engine", "aware-operational-portal-ui", "aware-public-ui", "aware-publicapi-documentation", "aware-rule-engine", "aware-service-dashboard-ui", "aware-session-manager", "builder-service", "coap-client", "coap-client-dtls", "coap-protocol-adaptor", "coap-protocol-adaptor-dtls", "command-service-aware", "docsapi", "feedback-service", "global-settings-service", "inclinometer-processor", "inclinometer-service", "location-service", "logstash-aware", "mockpublicapi", "msgdispatcher-pro-aware", "notification-service-aware", "nucleus_dm", "nucleus_dm-consumer", "nucleus_um", "playground-proxy", "profile-service-aware", "prom/blackbox-exporter", "public-ui", "route-config-api-aware", "rule-definition-service", "sensor-service-aware", "shadow-service", "shipment-processor", "swagger-common-ui", "telemetry-engine-aware", "telemetry-service-aware", "tenant-service-aware", "test-awarepublicapi", "tracker-service-aware", "tracker-shipment-service", "xns-service"]
# Glp-priv to Reg-priv Specific Configuration

## Reg private VPC Details
  reg_priv_vpc_id                         = "vpc-085b582d28a0db433"
  reg_priv_private_subnet_ids             = ["subnet-03c388ba49e5161f1", "subnet-02fcb314833921a83"] //privateA and privateB

## Reg Public VPC Details

  reg_pub_vpc_id                          = "vpc-0c76b4dc1e25ed3cd" // Public VPC-ID
  reg_pub_private_subnet_ids              = ["subnet-0c2648cca42671712", "subnet-012b87380d7c32d63"] //Public VPC-ID privateA and privateB

## Global Private VPC Details
  glb_priv_vpc_id                         = "vpc-0ee6c2bd189af14f7"
  glb_priv_private_subnet_ids             = ["subnet-0aa00034c810c9a37", "subnet-00104917571b02d35"] //privateA and privateB


## Global Public VPC Details
  glb_pub_vpc_id                          = "vpc-0bab03f8a8a362ae3" // Public VPC-ID
  glb_pub_private_subnet_ids              = ["subnet-00d27d96702c74654", "subnet-03d93546de97befc3"] // [Public-privateA, Public-privateB]
}