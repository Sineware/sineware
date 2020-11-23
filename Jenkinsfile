pipeline {
    agent any

    stages {
        stage('Prepare Build Environment') {
                steps {
                    echo 'Preparing directories...'
                    sh 'make clean'
                }
        }
        stage('Build Docker Container') {
            steps {
                echo 'Building the Docker container...'
                sh 'make build_container'
            }
        }
        stage('Build Adelie RootFS') {
            steps {
                echo 'Building Sineware Adelie RootFS...'
                sh 'make adelie_rootfs'
                //archiveArtifacts artifacts: 'artifacts/adelie-sineware.tar.gz', fingerprint: true
            }
        }
        stage('Build System RootFS') {
            steps {
                echo 'Building Sineware...'
                sh 'make system_rootfs'
                archiveArtifacts artifacts: 'artifacts/sineware.tar.gz', fingerprint: true
            }
        }
        stage('Build Test HDD Image') {
            steps {
                echo 'Building Sineware Testing IMG...'
                sh 'make sineware_img'
                archiveArtifacts artifacts: 'artifacts/sineware-hdd.img', fingerprint: true
            }
        }
    }
}