#!/bin/bash
source .env
case "$OSTYPE" in
  darwin*)
        curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
        sudo installer -pkg AWSCLIV2.pkg -target /
        sudo mkdir ~/.aws
        sudo aws configure set profile.default.region $region
        sudo aws configure set profile.default.aws_access_key_id $access_public
        sudo aws configure set profile.default.aws_secret_access_key $access_secret
        ;;
  linux*)
     echo "LINUX"
        type=$(awk '/^NAME/' /etc/*-release);
     if [ -f /etc/redhat-release ] ; then
            sudo dnf install awscli
            sudo mkdir ~/.aws
            sudo aws configure set profile.default.region $region
            sudo aws configure set profile.default.aws_access_key_id $access_public
            sudo aws configure set profile.default.aws_secret_access_key $access_secret
        elif [ -f /etc/SuSE-release ] ; then
            sudo zypper in aws-cli
            sudo mkdir ~/.aws
            aws configure set profile.default.region $region
            aws configure set profile.default.aws_access_key_id  $access_public
            aws configure set profile.default.aws_secret_access_key $access_secret
        elif [ $type  == 'NAME="Debian"' ] ; then
            sudo apt install awscli
            sudo mkdir ~/.aws
            sudo aws configure set profile.default.region $region
            sudo aws configure set profile.default.aws_access_key_id $access_public
            sudo aws configure set profile.default.aws_secret_access_key $access_secret
        elif [ $type == 'NAME="Ubuntu"' ] ; then
            sudo apt install awscli
            sudo mkdir /root/home/ubuntu/.aws
            sudo aws configure set profile.default.region $region
            sudo aws configure set profile.default.aws_access_key_id $access_public
            sudo aws configure set profile.default.aws_secret_access_key $access_secret
        fi
    ;;
  msys*)
        echo "WINDOWS"
        powerShell "msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi "

  ;;
  *)        echo "unknown: $OSTYPE" ;;
esac