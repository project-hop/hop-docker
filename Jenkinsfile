node {
  properties([
    [$class: 'BuildDiscarderProperty', 
      strategy: [
        $class: 'LogRotator', 
        artifactDaysToKeepStr: '', 
        artifactNumToKeepStr: 5]
    ],
    disableConcurrentBuilds(),
    rateLimitBuilds([count: 1, durationName: 'minute', userBoost: false])
  ])

  triggers {
    upstream(upstreamProjects: 'hop', threshold: hudson.model.Result.SUCCESS)
  }

  stage('Checkout') {
    checkout scm
  }

  stage('Upstream Variables') {
    def upstream = currentBuild.rawBuild.getCause(hudson.model.Cause$UpstreamCause)
    echo 'Upstream Description:' upstream?.shortDescription
    echo 'Upstream BuildNumber:' upstream?.upstreamBuild
    echo 'Upstream Project:' upstream?.upstreamProject
  }

}


// pipeline {
//   agent { label 'docker' }
//   options {
//     buildDiscarder(logRotator(numToKeepStr: '5'))
//   }
//   triggers {
//     upstream(upstreamProjects: 'hop', threshold: hudson.model.Result.SUCCESS)
//   }
//   stages {
//     stage('Build') {
//       steps {
//         sh 'echo Building'
//       }
//     }
//     stage('Upstream Variables') {
//       steps{
//         def upstream = currentBuild.rawBuild.getCause(hudson.model.Cause$UpstreamCause)
//         echo 'Upstream Description:' upstream?.shortDescription
//         echo 'Upstream BuildNumber:' upstream?.upstreamBuild
//         echo 'Upstream Project:' upstream?.upstreamProject
//       }
//     }
//     stage('Publish') {
//       when {
//         branch 'master'
//       }
//       steps {
//         //withDockerRegistry([ credentialsId: "6544de7e-17a4-4576-9b9b-e86bc1e4f903", url: "" ]) {
//         //  sh 'echo push to dockerhub'
//         //}
//       }
//     }
//   }
// }