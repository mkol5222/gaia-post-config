# GaiaOS cloud post-config script

## Discussion

Check Point GaiaOS booystrap script for cloud-init (Check Point's cloud config)
e.g.
https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/terraform/azure/single-gateway-new-vnet/cloud-init.sh#L10
is execured before VM configuration like First time configuration wizard / blink is done.

This is not proactical for changes that have to be done on top of configured VM.

This reporitory attempts to enhance cloud-init bootstrap script 
with code to be run post-configuration on fiest reboot of VM.

## Usage

```bash
CODE=$(cat ./post-config.sh | bzip2 -c | base64 -w 0)
echo $CODE

```

