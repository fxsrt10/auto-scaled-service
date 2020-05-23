#!/bin/bash

usage()
{
    echo "terraform is a prerequisite to running this application and will be included in the distribution"
    echo "usage: autoscaleapp [-a accesskey -s secretkey] | [-h help] | [-d destroy]]"
}

generateCredentials()
{
    touch credentials
    echo "[default]" > credentials
    echo "aws_access_key_id = $access" >> credentials
    echo "aws_secret_access_key = $secret" >> credentials

    ssh-keygen -t rsa -q -f "mykey" -N ""
}

terraformcompose()
{
    ./terraform init
    ./terraform plan -out out.txt
    ./terraform apply "out.txt"
}

terraformdestroy()
{
    ./terraform destroy -auto-approve
}
secret=
access=

while [ "$1" != "" ]; do
    case $1 in
        -a | --accesskey )      shift
                                access=$1
                                ;;
        -s | --secretkey )      shift
                                secret=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        -d | --help )           terraformdestroy
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ "$secret" != "" ] && [ "$access" != "" ]
then
    generateCredentials
    terraformcompose
else
    echo "Please put in a secretkey and/or accesskey"
fi