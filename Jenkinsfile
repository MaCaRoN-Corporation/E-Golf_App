pipeline {
  agent any
  stages {
    stage('Creation Sign Bundle') {
      steps {
        sh 'cd Application/android'
        echo 'Moving old version into folder ...'
        echo 'Creation of new Sign Bundle AAB ...'
        sh './gradlew bundleRelease prepareBundle'
        echo 'Commiting and pushing...'
        sh '''cd ..
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