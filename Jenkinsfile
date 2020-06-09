node {
  properties([
    [$class: 'BuildDiscarderProperty', 
      strategy: [
        $class: 'LogRotator', 
        artifactDaysToKeepStr: '', 
        artifactNumToKeepStr: '5']
    ],
    disableConcurrentBuilds(),
    rateLimitBuilds([count: 1, durationName: 'minute', userBoost: false]),
    pipelineTriggers([upstream(upstreamProjects: 'hop', threshold: hudson.model.Result.SUCCESS)]),
    parameters([
     string(name: 'PRM_BRANCHNAME', defaultValue: "master"),
     string(name: 'PRM_BUILD_NUMBER', defaultValue: "0"),
    ]),
  ])


  stage('Checkout') {
    checkout scm
  }

  stage('Upstream Variables') {
    echo "upstream Branch: ${params.PRM_BRANCHNAME}"
    echo "upstream Build Number: ${params.PRM_BUILD_NUMBER}"
  }

  stage('Build image') {
    docker.withRegistry('', 'dockerhub') {

        def customImage = docker.build("projecthop/hop:${env.BUILD_ID}")

        /* Push the container to the custom Registry */
        customImage.push()
    }
  }



}