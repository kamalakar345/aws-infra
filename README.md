# aws-infra
IAC for AWARE on AWS 
This repo creates the resources needed for setting up a new AWARE env,
Env will have 4 components i.e. **regional-private, regional-public, global-private, global-public** by default


## Note
**feature/<envionment>** will be the name of the environment it will be picked up automatically by the CICD pipeline

### Info
We have followed the concept of group_vars and host_vars similar to Ansible
In our Repo structure **_env_vars** will have all the configurations inside that **common_config.hcl** will have the common configs for the environment then each component specific **<component>.hcl** will server for the configuration respecitively

# Instructions
In the **deployment** folder we have component specific folders which has the **terragrunt.hcl** for reading common and environment specific configuration and specifying what resources needs to be deployed 
