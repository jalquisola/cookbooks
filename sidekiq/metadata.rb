description       'Sets up Sidekiq to start a number of workers and monitors them'
version           '0.1'
recipe            'sidekiq::deploy', 'Sets up sidekiq workers through monit'

depends 'deploy'
