# Use Elixir 1.12 as the base image
FROM elixir:1.12

# Install MySQL client
RUN apt-get update && \
    apt-get install -y default-mysql-client git

# Set environment variables
ENV MIX_ENV=dev

# Create app directory
WORKDIR /app

# Copy the application code to the container
COPY . /app

# Install dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod

# Set up the database
RUN mix ecto.create && \
    mix ecto.migrate

# Expose the port
EXPOSE 4000

