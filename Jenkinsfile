pipeline {
    agent {
        node { label 'macOS-runner' }
    } // iOS builds require a macOS agent with Xcode installed
    
    environment {
        WORKSPACE = 'automation_testing_safari_1.xcworkspace'
        SCHEME = 'automation_testing_safari_1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Run Automation Tests') {
            steps {
                // Executes UI and Unit tests on a simulated device
                sh "xcodebuild test -workspace ${WORKSPACE} -scheme ${SCHEME} -destination 'platform=macOS'"
            }
        }
    }
}
