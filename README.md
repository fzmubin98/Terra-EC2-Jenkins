# Terra-EC2-Jenkins
A terraform project run on Jenkins. It will have: creation of a basic EC2 instance, Jenkinsfile which will ask for a prompt to apply the terraform apply after plan, send the output of the changed, created or destroyed resources to an Email and Slack account, will check the terraform code with the help of tflint and find out the cost with infracost.
