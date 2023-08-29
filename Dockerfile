FROM nginx:1.25.2

# Copy shell scripts
COPY *.sh /docker-entrypoint.d/
RUN chmod a+x /docker-entrypoint.d/*.sh

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE 80

# Reduce logging verbosity
ENV NGINX_ENTRYPOINT_QUIET_LOGS="1"

# Provide default environment variables
ENV UPSTREAMS="hostname1:80,hostname2:80"
