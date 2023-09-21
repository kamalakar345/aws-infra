locals{
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  # region       = "us-west-2"
  # region_abbr  = "usw2"
  # environment = "reg"
  # admin_contact = "tpscloudops@qti.qualcomm.com"
  # service_id = "AWARE"
  # service_data = "env=reg"
  # aws_profile = "dev"
  # env      = "reg"
# Common variable reference comming from common_config.hcl 
  region                                  = "us-west-2"
  admin_contact                           = "aware.cloud.eng.devops@quicinc.com"
  service_id                              = "AWARE"
  aws_account                             = 608026881676
  aware_services                          = ["analytic-processor", "aware_common", "aware-common-ui", "aware-core", "aware-mock-api", "aware-notification-engine", "aware-operational-portal-ui", "aware-public-ui", "aware-publicapi-documentation", "aware-rule-engine", "aware-service-dashboard-ui", "aware-session-manager", "builder-service", "coap-client", "coap-client-dtls", "coap-protocol-adaptor", "coap-protocol-adaptor-dtls", "command-service-aware", "docsapi", "feedback-service", "global-settings-service", "inclinometer-processor", "inclinometer-service", "location-service", "logstash-aware", "mockpublicapi", "msgdispatcher-pro-aware", "notification-service-aware", "nucleus_dm", "nucleus_dm-consumer", "nucleus_um", "playground-proxy", "profile-service-aware", "prom/blackbox-exporter", "public-ui", "route-config-api-aware", "rule-definition-service", "sensor-service-aware", "shadow-service", "shipment-processor", "swagger-common-ui", "telemetry-engine-aware", "telemetry-service-aware", "tenant-service-aware", "test-awarepublicapi", "tracker-service-aware", "tracker-shipment-service", "xns-service"]
}