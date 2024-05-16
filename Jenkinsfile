// node {
    // stage('Artifactory configuration') {
    //     withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
    //                 bat '''cd Application
    //                 git config --global --add --bool push.autoSetupRemote true
    //                 git pull
    //             '''
    //             }
    // }

    // stage('Gradle build') {
    //     rtGradle.tool = "Gradle 8.2-rc-2"
    //     buildInfo = rtGradle.run rootDir: "Application/android/app/", tasks: 'bundleRelease prepareBundle'
    //     echo "${buildInfo}"
    //     bat '''ls Application/Releases/beta_versions/'''
    //     bat '''ls Application/Releases/release_versions'''
    // }
// }

pipeline {
    agent any

    // tools {
    //     gradle "Gradle 8.2-rc-2"
    // }

    stages {
        stage('GIT PULL') {
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
                    bat "cd Application"
                    bat "git config --global --add --bool push.autoSetupRemote true"
                    bat "git pull"
                }
            }
        }

        stage('NPM Setup') {
            steps {
                echo '[!!!] NPM Install ... [!!!]'
                // sh 'npm install'
            }
        }

        stage('Ionic Build') {
            steps {
                echo '[!!!] Ionic Build ... [!!!]'
                // sh 'ionic build'
            }
        }

        stage('Android Build') {
            steps {
                echo '[!!!] Build Ionic Capacitor ... [!!!]'
                // sh 'ionic capacitor build android'
            }
        }

        stage('Creation Sign Bundle') {
            steps {
                echo '[!!!] Moving old version into folder & Creation of new Sign Bundle AAB ... [!!!]'

                script {
                    def rtGradle = Artifactory.newGradleBuild()
                    rtGradle.tool = "Gradle 8.2-rc-2"
                    def buildInfo = rtGradle.run rootDir: "Application/android/app/", tasks: 'bundleRelease prepareBundle'
                    echo "${buildInfo}"
                }

                bat '''ls Application/Releases/beta_versions/'''
                bat '''ls Application/Releases/release_versions'''
            }
        }

        stage('GIT PUSH') {
            steps {
                echo '[!!!] Commiting and pushing... [!!!]'
                // withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
                //     bat "cd Application"
                //     bat "git config --global --add --bool push.autoSetupRemote true"
                //     bat "git add *"
                //     bat "git commit -m \"auto-publish commit\""
                //     bat "git push"
                // }
            }
        }

        stage('Upload to Play Store') {
            steps {
                script {
                    echo '[!!!] Choose Releases/[beta_version - release_version] .aab version [!!!]'
                    def versionProps = readProperties file: "Application/android/app/version.properties.txt"
                    def VERSION_TYPE = versionProps['VERSION_TYPE'].toString()

                    echo '[!!!] Publishing Android Bundle in Play Store ... [!!!]'
                    if (VERSION_TYPE == "debug") {
                        echo 'Publishing Beta Version ...'
                        // androidApkUpload googleCredentialsId: '6739ee96-d5d3-4cba-bef7-e72c58f92fe8', apkFilesPattern: 'Application/Releases/beta_versions/*-release.aab', rolloutPercentage: '100', trackName: 'internal' // internal/alpha/beta/production
                        echo '[!!!] Sign Bundle Version Publishing --> Done [!!!]'
                    } else if (VERSION_TYPE == "release") {
                        echo 'Publishing Beta Version ...'
                        // androidApkUpload googleCredentialsId: '6739ee96-d5d3-4cba-bef7-e72c58f92fe8', apkFilesPattern: 'Application/Releases/release_versions/*-release.aab', rolloutPercentage: '100', trackName: 'internal' // internal/alpha/beta/production
                        echo '[!!!] Sign Bundle Version Publishing --> Done [!!!]'
                    } else {
                        echo 'Publishing failed, try again looser !'
                    }
                }
            }
        }
    }
}