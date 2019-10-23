FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y nginx curl vim
ENV ADDRESSES=${ADDRESSES}
EXPOSE 80
WORKDIR /etc/nginx
ADD startup.sh /usr/startup.sh
RUN chmod 755 /usr/startup.sh
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx
CMD ["/usr/startup.sh"]