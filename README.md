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
CODE=$(cat ./post-config.sh | xz -c | base64 -w 0)
echo $CODE

cat << EOF
echo '$CODE' | base64 -d | xz -cd | tee /tmp/post-config.sh | bash
EOF
```

Resulting command is to be placed in boot strap script in VM's custom data - directly or using Terraform code - e.g. `bootstrap_script` variable - [doc](https://github.com/CheckPointSW/CloudGuardIaaS/blob/master/terraform/azure/single-gateway-new-vnet/README.md#terraformtfvars-variables).

Usage with `terraform.tfvars`:

```
bootstrap_script                = "echo '/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj4ASrAiRdABGIQkY99Bhqpmevep9xf6nTEoKAHp7CaXsa2+ILv7CmlRgQxic4qVYaSn7a0wlZDFhmlIvj7smFCURI52g1q2o0OubycuDd8FDbO/vXLZCFwkQUCynmX21Cl2VLR3uq/1HRjQEutDPXHiyeMXtlsOxAiC+O2xVTtTJWEo1SYSc7TuoUMX9FVZ1YYk92ELr7+EGPvf/jW5aR5DYPBtRKxX/OiEgNbuanyl0IQ7bkxosH3D9plKWiLnH6+KAsOzONCO5dFe0rZ7lmfEtDamv8d3tUXOuz07CW/VQymxwetmxtvaQ3Jg+KRaslXzLREjbK/7xfIi/MBCG5uAA+ohzcuf82eiX4Rq39TbNdEyJotDwUbkJ4F6SweAU0F4w+/pGgRSEnBbd8HyRXWAxolB70L9sUeEJKsExGTDDnnycbfrPInp1aGsUldPnSfI1w0H1VS60+5Oy/r1Jma6odxsuB9kcjJipSGukdIPKKiC2MbIhhNYkLX5+otFg3s6fDi02d2hG7EcapxHn3caDfp70O2HqR4kVU6sZ+mX2d5ySLt33bWPycQoQlvnyGGNVGeiK59NW+qZkOM0F2uA6CIe7QkIV8DzloJT18ks7bW7YqvdsprGCeU7nZMnH+OxlmpV7D/WdqpxCUxSej3T0fbdxNVRnRA5jwfQ2/66PLNNHp637aV8STqA7Z5rXt9Cc9SgW8xNWzTkWC1IVIoEVCMnJcPIlalJIAAE3sCl6N2ptjAAHABKwJAACb8VEvscRn+wIAAAAABFla' | base64 -d | xz -cd | tee /tmp/post-config.sh | bash"
```