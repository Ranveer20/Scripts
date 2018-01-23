pipeline {
  agent none
  stages {
    stage('Shell') {
      parallel {
        stage('Shell') {
          steps {
            sh 'echo "F5 url added"'
          }
        }
        stage('else') {
          steps {
            echo 'Fail to add'
          }
        }
      }
    }
    stage('Print') {
      steps {
        echo 'F5 added'
      }
    }
  }
  environment {
    Name = ''
    F5 = ''
  }
}