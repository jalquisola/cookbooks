description 'Writes a .env file with custom ENV values to apps deploy directories.'
version '0.1'

recipe 'environment_variables::deploy', 'Write a config/application.yml file to app\'s deploy directory. Relies on restart command declared by rails::configure recipe. (Intended as part of deploy OpsWorks events.)'
