def SKIP_ALL_STAGES
pipeline {
    agent any

    stages {
        stage('Check Auth Commit') {
            steps {
                script {
                    echo '[!!!] Check Auth Commit [!!!]'
                    // def commitMessage = `sh git show -s --format=%s`
                    // sh " 'git show -s --format=%s' > command"
                    // env.GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
                    // def commitMessage

                    withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
                        bat "'git show -s --format=%s' > command"
                    }
                    
                    def commitMessage = readFile('command').trim()

                    echo "${commitMessage}"
                    SKIP_ALL_STAGES = true
                    
                    // if (commitMessage == "" || commitMessage == null) {
                    //     error("Commit message does not follow conventional commit format")
                    // } else if (commitMessage == "auto-publish commit") {
                    //     SKIP_ALL_STAGES = true
                    // }
                }
            }
        }

        stage('GIT PULL') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
                    bat "cd Application"
                    bat "git config --global --add --bool push.autoSetupRemote true"
                    bat "git pull"
                }
            }
        }

        stage('NPM Setup') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                echo '[!!!] NPM Install ... [!!!]'
                sh 'npm install'
            }
        }

        stage('Ionic Build') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                echo '[!!!] Ionic Build ... [!!!]'
                sh 'ionic build'
            }
        }

        stage('Android Build') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                echo '[!!!] Build Ionic Capacitor ... [!!!]'
                sh 'ionic capacitor build android'
            }
        }

        stage('Creation Sign Bundle') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                echo '[!!!] Moving old version into folder & Creation of new Sign Bundle AAB ... [!!!]'

                script {
                    def rtGradle = Artifactory.newGradleBuild()
                    rtGradle.tool = "Gradle"
                    rtGradle.run rootDir: "Application/android/app/", tasks: 'bundleRelease' //prepareBundle
                }

                bat '''ls Application/Releases/beta_versions/'''
                bat '''ls Application/Releases/release_versions'''
            }
        }

        stage('GIT PUSH') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                echo '[!!!] Commiting and pushing... [!!!]'
                withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
                    bat "cd Application"
                    bat "git config --global --add --bool push.autoSetupRemote true"
                    bat "git add *"
                    bat "git commit -m \"auto-publish commit\""
                    bat "git push"
                }
            }
        }

        stage('Upload to Play Store') {
            when { expression { SKIP_ALL_STAGES != true } }
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