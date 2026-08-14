pipeline {
  agent any
  parameters {
    string(name: 'SERVICE_REF', defaultValue: 'develop', description: 'Branch/tag/SHA')
  }
  stages {
    stage('Checkout') {
      steps { git branch: params.SERVICE_REF, url: 'https://github.com/PlataformaIntegradaInvestigadores/RAG.git' }
    }
    stage('Quality Gate') {
      steps {
        sh 'ruff check . && black --check .'
        sh 'pytest --cov --cov-fail-under=60'
      }
    }
    stage('Build')       { steps { sh 'docker compose build' } }
    stage('Deploy')      { steps { sh 'docker compose up -d' } }
    stage('Healthcheck') { steps { sh 'curl -f http://localhost:8181/health || exit 1' } }
    stage('Manifest')    { steps { sh 'echo "MANIFEST update: rag SHA=$GIT_COMMIT"' } }
  }
  post { failure { echo 'Deploy failed. Revisar logs.' } }
}
