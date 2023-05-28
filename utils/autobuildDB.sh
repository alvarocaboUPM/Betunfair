#!/bin/bash

########################################
############ RUN AS ROOT! #############
# Careful, it will delete dev and test dbs!
########################################
# Borrar betunfair y betunfair_test
mix ecto.drop -r BetUnfair.Repo
MIX_ENV=test mix ecto.drop -r BetUnfair.Repo 

# Correr init.sql para crear las bases de datos
mysql -u root -p < utils/init.sql

# Correr las migraciones
MIX_ENV=dev mix ecto.migrate -r BetUnfair.Repo
MIX_ENV=test mix ecto.migrate -r BetUnfair.Repo

# Establecer el entorno en test
export MIX_ENV=test



