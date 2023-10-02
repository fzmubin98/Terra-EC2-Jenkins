pipeline{
    parameters{
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Do you want to apply the generated plan?')
    }

    // environment{
    //     AWS_Access_Key_ID = credentials('AWS_Access_Key_ID')
    //     AWS_Secret_Access_Key = credentials('AWS_Secret_Access_Key')
    // }

    agent any
    stages{
        stage('Checkout') {
            steps{
                script{
                    dir('Terraform'){
                        git branch: 'main', url: 'https://github.com/fazle-mubin/Terra-EC2-Jenkins.git'
                    }
                }
            }
        }

        stage('Initiating tflint'){
            steps{
                echo 'Testing phase'
                echo '------------------------------------------------'
                sh 'pwd ; cd Terraform/Terraform-files ; tflint --init'
            }
        }

        stage('Applying tflint'){
            steps{
                echo 'Applying the Tests'
                echo '------------------------------------------------'
                sh 'pwd ; cd Terraform/Terraform-files ; tflint'
            }
        }        

        stage('Terraform Init'){
            steps{
                withAWS(credentials: 'AWS_Credentials', region: 'us-east-1'){
                    echo 'Terraform phase'
                    echo '------------------------------------------------'                    
                    sh 'pwd ; cd Terraform/Terraform-files ; terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withAWS(credentials: 'AWS_Credentials', region: 'us-east-1'){
                    sh "pwd;cd Terraform/Terraform-files ; terraform plan -out tfplan"
                    sh 'pwd;cd Terraform/Terraform-files ; terraform show -no-color tfplan > tfplan.txt'
                    sh 'pwd;cd Terraform/Terraform-files ; cp tfplan.txt /var/lib/jenkins/workspace/Terraform-EC2/tfplanbck.txt'
                }
            }
        }

        stage('Terraform Plan Approval'){
            when{
                not{
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps{
                script {
                    def plan = readFile 'Terraform/Terraform-files/tfplan.txt'
                    input message: "Apply the plan or not?"
                    parameters: [text(name:'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage("Terraform Apply"){
            steps{
                withAWS(credentials: 'AWS_Credentials', region: 'us-east-1'){
                    sh 'cd Terraform/Terraform-files ; terraform apply -input=false tfplan'}
            }
        }

        stage("Terraform Destroy"){
            steps{
                withAWS(credentials: 'AWS_Credentials', region: 'us-east-1'){
                    sh 'cd Terraform/Terraform-files ; terraform destroy -auto-approve'}
            }
        }
    }

    post {
        always {
            // One or more steps need to be included within each condition's block.
            echo "Sending Email"
            emailext attachLog: true, body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}", subject: 'Jenkins Build Notification', to: 'fazle.mubin1234@gmail.com'
            echo "Sending Slack Message"
            slackSend channel: 'jenkins', color: '#FF0000', message: "Project: ${env.JOB_NAME}, Build Number: ${env.BUILD_NUMBER}, Build Status:${currentBuild.result}, Build URL: ${env.BUILD_URL}", teamDomain: 'Jenkins-Portal', tokenCredentialId: 'Slack_ID'
            echo "Sending Slack Notification"
            script{
            def location = "tfplanbck.txt"
            slackUploadFile channel: 'terra-jenkins-ec2', credentialId: 'Slack-jenkins-EC2', filePath: location, initialComment: 'Sending the tfplanbck.txt'
            }
                
        }
    }

}