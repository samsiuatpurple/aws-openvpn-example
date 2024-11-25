This repo contains an AWS Cloudformation template that provisions an OpenVPN Access Server in an EC2 instance.
It sets up two users by default `openvpn`(admin) and `openvpnuser`. This OpenVPN Access Server will route all client traffic to the VPN server.

## Disclaimer
This repository contains an example for provisioning an OpenVPN Access Server on AWS. Use this code at your own risk. I, the author of this repo, am not responsible for any costs, liabilities, or damages incurred from using this repository. Ensure you review and understand the OpenVPN, and AWS pricing and configuration before deployment.

## [OpenVPN](https://openvpn.net/)
OpenVPN Access Server is a comprehensive VPN solution designed for secure remote access and site-to-site connectivity. It provides an easy-to-use web interface for configuration and management, supports a variety of authentication methods, and ensures encrypted data transmission.

## Prerequisites
1. An activation key for [OpenVPN Access Server](https://myaccount.openvpn.com/signup/product-select). You can get one for 2 free connections. 
1. An active AWS account
1. AWS profile that have sufficient permissions to create and manage EC2 instance, and use Cloudformation
1. AWS cli
1. [jq](https://jqlang.github.io/jq/)

## How?
It is supposed that you have set up the AWS cli environment on your machine already.

1. Make a copy `parameters.json.example` and change its name to `parameters.json`
1. Fill out the values in `parameters.json`, except `KeyName`, `VpcId`, and `InstanceName`, which will be populated automatically.
1. Run 
```
./provision-openvpn-server.sh <aws profile name> <resource suffix> <region e.g. ap-southeast-2>
```
1. Once successful, it will show the url of the admin portal. Now you have an admin user called `openvpn` with the Admin Password, and a user called `openvpnuser` with the User Password you have specified in `parameters.json`.
1. You will find a `.pem` file generated in the working folder, you can use it to ssh to the EC2 instance.
1. When you don't need the server any more
```
./clean-up.sh <aws profile name> <resource suffix> <region e.g. ap-southeast-2>
``` 