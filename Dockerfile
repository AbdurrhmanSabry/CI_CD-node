FROM node:12
COPY nodeapp /nodeapp
WORKDIR /nodeapp
RUN npm install
ENV  RDS_HOSTNAME ="localhost"
ENV  RDS_USERNAME ="admin"
ENV  RDS_PASSWORD ="admin"
ENV  RDS_PORT   ="3306"
ENV  REDIS_HOSTNAME ="localhost"
ENV  REDIS_PORT ="6379"
CMD ["node", "/nodeapp/app.js"]
  