def VERSION_TYPE
def testtoto() {
    def propertiesPath = "Application/android/app/version.properties.txt"
    // def versionPropsFile = file(propertiesPath)
    def versionProps = readProperties file: propertiesPath

    // if (versionPropsFile.canRead()) {
        // def Properties versionProps = new Properties()
        // versionProps.load(new FileInputStream(versionPropsFile))

        VERSION_TYPE = versionProps['VERSION_TYPE'].toString()
    // }
}


pipeline {
    agent any

    tools {
        gradle "Gradle 8.2-rc-2"
    }

    stages {
        stage('NPM Setup') {
            steps {
                echo 'NPM Install ...'
                sh 'npm install'
            }
        }

        stage('Ionic Build') {
            steps {
                echo 'Ionic Build ...'
                sh 'ionic build'
            }
        }

        stage('Android Build') {
            steps {
                echo 'Build Ionic Capacitor ...'
                sh 'ionic capacitor build android'
            }
        }

        stage('Creation Sign Bundle') {
            steps {
                echo 'Moving old version into folder ...'
                echo 'Creation of new Sign Bundle AAB ...'
                sh '.\\Application\\android\\gradlew bundleRelease prepareBundle'
                bat '''ls Application/Releases/beta_versions/'''
                bat '''ls Application/Releases/release_versions'''
            }
        }

        stage('GIT Update') {
            steps {
                echo 'Commiting and pushing...'
                withCredentials([gitUsernamePassword(credentialsId: 'Jenkins - E-Golf App', gitToolName: 'Default')]) {
                    bat '''cd Application
                    git config --global --add --bool push.autoSetupRemote true
                    git add *
                    git commit -m "auto-publish commit"
                    git push
                '''
                }
            }
        }

        stage('Upload Sign Bundle to Play Store') {
            steps {
                script {
                    testtoto()
                }
                echo 'TODO: Choose Releases/[beta_version - release_version] .aab version'
                echo "VERSION_TYPE = ${VERSION_TYPE}"

                echo 'Publishing Android Bundle in Play Store ...'
                // androidApkUpload googleCredentialsId: 'Google Play Key', apkFilesPattern: 'Application/Releases/beta_versions/*-release.aab', trackName: 'beta' // alpha/beta/production
                // androidApkUpload googleCredentialsId: 'Google Play Key', apkFilesPattern: 'Application/Releases/release_versions/*-release.aab', trackName: 'production' // alpha/beta/production
                echo 'Sign Bundle Version Publishing --> Done'
            }
        }
    }
}