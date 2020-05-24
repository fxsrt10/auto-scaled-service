

# Auto-scale-application Instructions

### Usage
If you have already terraform for your distribution


    ./autoscaleapp.sh -a *ACCESSKEY* -s *SECRETKEY*


If you don't have a terraform distribution you can use the one provided(works with Linux Distros(WLS on Windows 10) except Mac)

    ./autoscaleapp.sh -a *ACCESSKEY* -s *SECRETKEY* -dr

When everything is up and running you should receive a DNS of the ELB to go to

When you're ready to spin it down just put:

    ./autoscaleapp.sh -d -dr

### Notes
If you want to manually run terraform yourself you just need to run the following commands and provide a file labeled credentials and a private and public key pair named mykey and mykey.pub

The contents of the credentials file should be as such:

    [default]
    aws_access_key_id = AKIAQBXXXXXXXXXXXXXXXXXXXXXX
    aws_secret_access_key = BOXXXXXXXXXXXXXXXXXXXXXXX
OR
go to the provider.tf file and replace credentials with the path of your credentials file

Then run:

    terraform init
    terraform plan -out "out.txt"
    terraform apply "out.txt"
