# TODO: Specify imave with :<version>-slim
FROM nginx
RUN apt-get update -qq && apt-get -y install apache2-utils

ENV APP_PATH=/exhibits
WORKDIR $APP_PATH

# Create log directory
# RUN mkdir log

# Copy over static assets
COPY public public/

# Copy nginx config template
# COPY docker/web/nginx.conf /tmp/docker.nginx

# Substitute variable references in the nginx config template for real values from the environment
# put the final config in its place
# RUN envsubst '$APP_PATH' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf

EXPOSE 80

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
