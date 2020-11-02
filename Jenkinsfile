pipeline {
    agent any

    stages {
        stage('Build RootFS') {
            steps {
                echo 'Building Sineware...'
                sh './build-everything.sh'
                archiveArtifacts artifacts: 'build-scripts/output/sineware.tar.gz', fingerprint: true
            }
        }
        stage('Build Test ISO') {
            steps {
                echo 'Building Sineware Testing ISO...'
                sh './build-iso.sh'
                archiveArtifacts artifacts: 'iso-build-scripts/output/sineware.iso', fingerprint: true
            }
        }
    }
}