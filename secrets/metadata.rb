description 'Writes the secrets.yml file to the app\' config directory.'
version '0.1'

recipe 'secrets::deploy', 'Write a config/secrets.yml file to app\'s deploy directory. Relies on restart command declared by rails::configure recipe. (Intended as part of deploy OpsWorks events.)'
