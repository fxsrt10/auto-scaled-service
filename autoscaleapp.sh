#!/bin/bash

usage()
{
    echo "terraform is a prerequisite to running this application and will be included in the distribution"
    echo "usage: ./autoscaleapp [-a accesskey -s secretkey -dr] | [-h help] | [-d destroy]]"
    echo "If you already have terraform you can just run ./autoscaleapp.sh -a accesskey -s secretkey to spin up and "
}

generateCredentials()
{
    touch credentials
    echo "[default]" > credentials
    echo "aws_access_key_id = $access" >> credentials
    echo "aws_secret_access_key = $secret" >> credentials

    ssh-keygen -t rsa -q -f "mykey" -N ""
}

terraformcomposedistro()
{
    terraformdist/terraform init
    terraformdist/terraform plan -out out.txt
    terraformdist/terraform apply "out.txt"
}

terraformdestroydistro()
{
    terraformdist/terraform destroy -auto-approve
}

terraformcompose()
{
    terraform init
    terraform plan -out out.txt
    terraform apply "out.txt"
}

terraformdestroy()
{
    terraform destroy -auto-approve
}

secret=
access=
usedistro=
destroy=
while [ "$1" != "" ]; do
    case $1 in
        -a | --accesskey )      shift
                                access=$1
                                ;;
        -dr | --distro )      usedistro=1
                                ;;
        -s | --secretkey )      shift
                                secret=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        -d | --destroy )        destroy=1
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ "$secret" != "" ] && [ "$access" != "" ]
then
    generateCredentials
    if [ "$usedistro" == "1" ]
    then
    terraformcomposedistro
    else
        terraformcompose
    fi
fi

if [ "$destroy" == "1" ]
then
    if [ "$usedistro" == "1" ]
    then
    terraformdestroydistro
    else
        terraformdestroy
    fi
fi