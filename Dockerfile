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
RUN mix local.rebar --force && \
    mix deps.get

# Set up the database
RUN service mariadb start && \
    sleep 1 && \
    mysql -u root < utils/init.sql && \
    mix ecto.create && \
    mix ecto.migrate

# Expose the port
EXPOSE 4000
