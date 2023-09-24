# GaiaOS cloud post-config script

## Problem to address

Check Point GaiaOS bootstrap script for cloud-init (Check Point's cloud config)
delivered via [VM's custom data](https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/terraform/azure/single-gateway-new-vnet/cloud-init.sh#L10)
is executed before CHKP's VM configuration procedure (like First time configuration wizard / blink) is done.

This is not practical for changes that have to be done later - on top of configured VM.

This reporitory attempts to enhance cloud-init bootstrap script 
with code to be run post-configuration on first reboot of VM.

## Usage

This is how to produce bootstrap script command to seed and register post-config actions. Post config actions can be placed into `if` condition inside `run_only_once` function of `post-config.sh`

```bash
CODE=$(cat ./post-config.sh | bzip2 -c | base64 -w 0)
echo $CODE

cat << EOF
echo "$CODE" | base64 -d | bzip2 -cd | tee /tmp/post-config.sh | sh
EOF
```

Resulting command is to be placed in boot strap script in VM's custom data - directly or using Terraform code - e.g. `bootstrap_script` variable - [doc](https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/terraform/azure/single-gateway-new-vnet/README.md#terraformtfvars-variables).
