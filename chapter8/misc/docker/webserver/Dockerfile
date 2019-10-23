FROM ubuntu:latest
# Install dependencies
RUN apt-get update
RUN apt-get install -y nginx curl vim

# Copy static files over
COPY index.html /var/www/html
ENV BG_COLOR=${BG_COLOR}
ENV NAME=${NAME}

# Copy nginx config
COPY webserver.conf /etc/nginx/sites-available

# Expose port and start nginx
EXPOSE 80
ADD startup.sh /usr/startup.sh
RUN chmod 755 /usr/startup.sh
CMD ["/usr/startup.sh"]