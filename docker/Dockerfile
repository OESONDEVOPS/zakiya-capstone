FROM nginx:alpine
# This Dockerfile is for building a Docker image for a web application using Nginx.

# Create a system group and user for Nginx
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Create necessary directories and set permissions for appuser
RUN mkdir -p /var/run/nginx && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/log/nginx && \
    chown -R appuser:appgroup /var/run/nginx && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    chown -R appuser:appgroup /usr/share/nginx/html

# Copy your web application files and custom Nginx configuration
COPY ./my_app/src/index.html /usr/share/nginx/html/
COPY ./my_app/resources /usr/share/nginx/html/resources/
COPY ./my_app/nginx.conf /etc/nginx/nginx.conf

# Ensure appuser owns the content directory
RUN chown -R appuser:appgroup /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY ./my_app/nginx.conf /etc/nginx/nginx.conf
EXPOSE 8080
USER appuser
# Command to run Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]