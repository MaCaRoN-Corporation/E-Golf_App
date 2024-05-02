/* groovylint-disable-next-line CompileStatic */
pipeline {
    agent any
    // agent any
    // environment {
    //     PATH = '/usr/local/bin:/usr/bin:/bin'
    // }
    // stage('NPM Setup') {
    //     steps {
    //         sh 'npm install'
    //     }
    // }

    // stage('Ionic Build') {
    //     steps {
    //         sh 'ionic build'
    //     }
    // }

    // stage('Android Build') {
    //     steps {
    //         sh 'ionic capacitor build android'
    //     }
    // }

    stages {
        stage('Creation Sign Bundle') {
            steps {
                echo 'Moving old version into folder ...'
                echo 'Creation of new Sign Bundle AAB ...'
                bat '''cd Application/android
                start gradlew bundleRelease prepareBundle'''
                echo 'Commiting and pushing...'
            }
        }

        stage('GIT Update') {
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
                    bat '''cd Application
                    git add *
                    git commit -m "auto-publish commit"
                    git push'''
                }
            }
        }

        stage('Deploiement Sign Bundle') {
        steps {
            echo 'TODO: Choose Releases/[beta_version - release_version] .aab version'
            echo 'Publishing Android Bundle in Play Store ...'
        }
        }

        stage('Publish Android') {
        steps {
            echo 'Publish Android API Action'
        }
        }
    }
}