def VERSION_TYPE
// Get Artifactory server instance, defined in the Artifactory Plugin administration page.
// def server = Artifactory.server "SERVER_ID"
// Create an Artifactory Gradle instance.
def rtGradle = Artifactory.newGradleBuild()
def buildInfo

pipeline {
    agent any

    environment {
        SERVER_NAME = "dev-server"
    }

    tools {
        gradle "Gradle 8.2-rc-2"
    }

    stages {
        // stage('Build') {
        //     steps {
        //         echo '[!!!] Build ... [!!!]'
        //         sh 'git log'
        //         sh 'cd ~/workspace/deployment-staging && ansible-playbook playbook_dir/deployment.yml -i inventories/hosts -l ${SERVER_NAME}'
        //     }
        // }

        // stage('NPM Setup') {
        //     steps {
        //         echo '[!!!] NPM Install ... [!!!]'
        //         sh 'npm install'
        //     }
        // }

        // stage('Ionic Build') {
        //     steps {
        //         echo '[!!!] Ionic Build ... [!!!]'
        //         sh 'ionic build'
        //     }
        // }

        // stage('Android Build') {
        //     steps {
        //         echo '[!!!] Build Ionic Capacitor ... [!!!]'
        //         sh 'ionic capacitor build android'
        //     }
        // }

        stage('Creation Sign Bundle') {
            steps {
                echo '[!!!] Moving old version into folder & Creation of new Sign Bundle AAB ... [!!!]'
                
                
                // withGradle {
                //     sh '.\\Application\\android\\gradlew bundleRelease prepareBundle --scan'
                // }

                // Tool name from Jenkins configuration
                rtGradle.tool = "Gradle 8.2-rc-2"
                // Set Artifactory repositories for dependencies resolution and artifacts deployment.
                // rtGradle.deployer repo:'ext-release-local', server: server
                // rtGradle.resolver repo:'remote-repos', server: server
                Application\android\app\build.gradle
                buildInfo = rtGradle.run rootDir: "Application/android/app/build.gradle/", buildFile: 'build.gradle', tasks: 'bundleRelease prepareBundle'

                echo "${buildInfo}"
                bat '''ls Application/Releases/beta_versions/'''
                bat '''ls Application/Releases/release_versions'''
            }
        }

        // stage('GIT Update') {
        //     steps {
        //         echo '[!!!] Commiting and pushing... [!!!]'
        //         withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
        //             bat '''cd Application
        //             git config --global --add --bool push.autoSetupRemote true
        //             git add *
        //             git commit -m "auto-publish commit"
        //             git push
        //         '''
        //         }
        //     }
        // }

        // stage('Upload to Play Store') {
        //     steps {
        //         script {
        //             echo '[!!!] Choose Releases/[beta_version - release_version] .aab version [!!!]'
        //             def versionProps = readProperties file: "Application/android/app/version.properties.txt"
        //             VERSION_TYPE = versionProps['VERSION_TYPE'].toString()

        //             echo '[!!!] Publishing Android Bundle in Play Store ... [!!!]'
        //             if (VERSION_TYPE == "debug") {
        //                 echo 'Publishing Beta Version ...'
        //                 androidApkUpload googleCredentialsId: '6739ee96-d5d3-4cba-bef7-e72c58f92fe8', apkFilesPattern: 'Application/Releases/beta_versions/*-release.aab', rolloutPercentage: '100', trackName: 'internal' // internal/alpha/beta/production
        //                 echo '[!!!] Sign Bundle Version Publishing --> Done [!!!]'
        //             } else if (VERSION_TYPE == "release") {
        //                 echo 'Publishing Beta Version ...'
        //                 androidApkUpload googleCredentialsId: '6739ee96-d5d3-4cba-bef7-e72c58f92fe8', apkFilesPattern: 'Application/Releases/release_versions/*-release.aab', rolloutPercentage: '100', trackName: 'internal' // internal/alpha/beta/production
        //                 echo '[!!!] Sign Bundle Version Publishing --> Done [!!!]'
        //             } else {
        //                 echo 'Publishing failed, try again looser !'
        //             }
        //         }
        //     }
        // }
    }
}