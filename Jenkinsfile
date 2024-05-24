def SKIP_ALL_STAGES
pipeline {
    agent any

    stages {
        stage('Check Auth Commit') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                script {
                    echo '[!!!] Check Auth Commit [!!!]'
                    def commitMessage

                    for ( changeLogSet in currentBuild.changeSets){
                        for (entry in changeLogSet.getItems()){
                            commitMessage = entry.msg
                        }
                    }

                    echo env.BRANCH_NAME
                    if (commitMessage == "" || commitMessage == null) {
                        error("Commit message does not follow conventional commit format")
                    } else if (commitMessage == "auto-publish commit") {
                        SKIP_ALL_STAGES = true
                    } else if (!commitMessage.startsWith('/bundle') && env.BRANCH_NAME != "main" && env.BRANCH_NAME != "rqt" && env.BRANCH_NAME != "dev") {
                        SKIP_ALL_STAGES = true
                    }
                }
            }
        }

        stage('GIT PULL & SYNC GIT DEPENDENCIES') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'GitHub_MaCaRoN', gitToolName: 'Default')]) {
                    sh "git pull"

                    sh "git clone https://github.com/MaCaRoN-Corporation/E-Golf_App-Releases.git"
                    sh "mv -n E-Golf_App-Releases/* Application/"
                    sh "mv -n E-Golf_App-Releases/android/app/* Application/android/app"
                    sh "rm -rf E-Golf_App-Releases/"

                    sh "git clone https://github.com/MaCaRoN-Corporation/E-Golf_App-Dependencies.git"
                    sh "mv -n E-Golf_App-Dependencies/Application/* Application/"
                    sh "mv -n E-Golf_App-Dependencies/Application/android/* Application/android"
                    sh "rm -rf E-Golf_App-Dependencies/"
                }
            }
        }

        stage('NPM Setup') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                echo '[!!!] NPM Setup ... [!!!]'
                sh '''cd Application/
                npm upgrade'''
                sh '''cd Application/
                npm install'''
                sh '''cd Application/
                npm audit fix'''
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
            }
        }

        stage('GIT PUSH') {
            when { expression { SKIP_ALL_STAGES != true } }
            steps {
                echo '[!!!] Commiting and pushing... [!!!]'
                withCredentials([gitUsernamePassword(credentialsId: 'GitHub_MaCaRoN', gitToolName: 'Default')]) {
                    sh '''cd Application
                    git remote set-url origin config https://github.com/MaCaRoN-Corporation/E-Golf_App-Releases.git
                    git config --global --add --bool push.autoSetupRemote true
                    git config advice.addIgnoredFile false
                    git add Releases/*
                    git add android/app/version.properties.txt
                    git commit -m \"auto-publish commit\"
                    git push'''
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

                    if (VERSION_TYPE == "internal") {
                        echo '[!!!!!!!!!!!!!!!!] INTERNAL VERSION [!!!!!!!!!!!!!!!!!]'
                        echo '[!!!] Publishing Android Bundle in Play Store ... [!!!]'
                        echo '[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]'
                        androidApkUpload googleCredentialsId: 'Google_Play_Store', apkFilesPattern: 'Application/Releases/internal_versions/*-release.aab', rolloutPercentage: '100', trackName: 'internal' // internal/alpha/beta/production
                    } else if (VERSION_TYPE == "alpha") {
                        echo '[!!!!!!!!!!!!!!!!!!] ALPHA VERSION [!!!!!!!!!!!!!!!!!!]'
                        echo '[!!!] Publishing Android Bundle in Play Store ... [!!!]'
                        echo '[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]'
                        androidApkUpload googleCredentialsId: 'Google_Play_Store', apkFilesPattern: 'Application/Releases/alpha_versions/*-release.aab', rolloutPercentage: '100', trackName: 'alpha' // internal/alpha/beta/production
                    } else if (VERSION_TYPE == "beta") {
                        echo '[!!!!!!!!!!!!!!!!!!] BETA VERSION [!!!!!!!!!!!!!!!!!!!]'
                        echo '[!!!] Publishing Android Bundle in Play Store ... [!!!]'
                        echo '[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]'
                        // androidApkUpload googleCredentialsId: 'Google_Play_Store', apkFilesPattern: 'Application/Releases/beta_versions/*-release.aab', rolloutPercentage: '100', trackName: 'beta' // internal/alpha/beta/production
                    } else if (VERSION_TYPE == "production") {
                        echo '[!!!!!!!!!!!!!!!] PRODUCTION VERSION [!!!!!!!!!!!!!!!!]'
                        echo '[!!!] Publishing Android Bundle in Play Store ... [!!!]'
                        echo '[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]'
                        // androidApkUpload googleCredentialsId: 'Google_Play_Store', apkFilesPattern: 'Application/Releases/production_versions/*-release.aab', rolloutPercentage: '100', trackName: 'production' // internal/alpha/beta/production
                    } else {
                        echo 'Publishing failed, try again looser !'
                    }
                }
            }
        }
    }
}
