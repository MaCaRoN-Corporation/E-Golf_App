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
            bat 'cd Application/android'
            echo 'Moving old version into folder ...'
            echo 'Creation of new Sign Bundle AAB ...'
            bat 'start "gradlew bundleRelease prepareBundle"'
            echo 'Commiting and pushing...'
            bat '''cd ..
            git add *
            git commit -m "auto-publish commit"
            git push'''
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