def SKIP_ALL_STAGES
pipeline {
    agent any

    stages {
        stage('AUTHENTIFICATION CHECK') {
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
                        timeout(time: 5, unit: 'MINUTES') {
                            input message:'Lancement manuel détecté. Lancer un déploiement complet ?'
                        }
                    } else if (!commitMessage.startsWith('/bundle') && env.BRANCH_NAME != "main" && env.BRANCH_NAME != "rqt" && env.BRANCH_NAME != "dev") {
                        SKIP_ALL_STAGES = true
                    }
                }
            }
        }

        stage('GIT PULL & SYNC') {
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

        stage('SIGN BUNDLE CREATION') {
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
                    sh "git clone https://github.com/MaCaRoN-Corporation/E-Golf_App-Releases.git"
                    sh "rm -rf E-Golf_App-Releases/Releases/"
                    sh "rm -rf E-Golf_App-Releases/android/"

                    sh "cp -r Application/Releases/ E-Golf_App-Releases/"
                    sh "mkdir E-Golf_App-Releases/android/"
                    sh "mkdir E-Golf_App-Releases/android/app/"
                    sh "cp Application/android/app/version.properties.txt E-Golf_App-Releases/android/app/"

                    sh '''cd E-Golf_App-Releases
                    git add Releases/*
                    git add android/app/version.properties.txt
                    git commit -m \"auto-publish commit\"
                    git push
                    '''

                    sh "rm -rf E-Golf_App-Releases/"
                }
            }
        }

        stage('PLAY STORE UPLOAD') {
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
                        // timeout(time: 5, unit: 'MINUTES') { input message:'Voulez-vous vraiment livrer en TEST OUVERT ?' }
                        // androidApkUpload googleCredentialsId: 'Google_Play_Store', apkFilesPattern: 'Application/Releases/beta_versions/*-release.aab', rolloutPercentage: '100', trackName: 'beta' // internal/alpha/beta/production
                    } else if (VERSION_TYPE == "production") {
                        echo '[!!!!!!!!!!!!!!!] PRODUCTION VERSION [!!!!!!!!!!!!!!!!]'
                        echo '[!!!] Publishing Android Bundle in Play Store ... [!!!]'
                        echo '[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]'
                        // timeout(time: 5, unit: 'MINUTES') { input message:'Voulez-vous vraiment livrer en PRODUCTION ?' }
                        // androidApkUpload googleCredentialsId: 'Google_Play_Store', apkFilesPattern: 'Application/Releases/production_versions/*-release.aab', rolloutPercentage: '100', trackName: 'production' // internal/alpha/beta/production
                    } else {
                        echo 'Publishing failed, try again looser !'
                    }
                }
            }
        }
    }
}