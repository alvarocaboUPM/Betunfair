# Use Elixir 1.12 as the base image
FROM elixir:1.12

# Install MariaDB server and client
RUN apt-get update && \
    apt-get install -y mariadb-server default-mysql-client git

# Set environment variables
ENV MIX_ENV=dev

# Create app directory
WORKDIR /app

# Copy the application code to the container
COPY . /app

# Install dependencies
RUN mix local.hex --force && \
    mix deps.get

# Set up the database
RUN service mariadb start && \
    sleep 1 && \
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS betunfair; CREATE DATABASE IF NOT EXISTS betunfair_test; CREATE USER 'betunfair'@'localhost' IDENTIFIED BY '9sX5^6a2jJng'; GRANT ALL PRIVILEGES ON betunfair.* TO 'betunfair'@'localhost'; GRANT ALL PRIVILEGES ON betunfair_test.* TO 'betunfair'@'localhost'; FLUSH PRIVILEGES;" && \
    mix ecto.create && \
    mix ecto.migrate

# Expose the port
EXPOSE 4000
