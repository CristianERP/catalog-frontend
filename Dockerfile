# Dockerfile to build and server the Angular application
 

###############
### STAGE 1: Build app
###############
FROM node:16-alpine as build

WORKDIR /usr/local/app

# Add the source code to app
COPY package*.json /usr/local/app/

# Install all the dependencies
RUN npm install

COPY . .

RUN npm run build

###############
### STAGE 2: Serve app with nginx ###
###############
FROM nginx:1.21.4-alpine
#Define las variables de ambiente

ENV CATALOG_URL=http://localhost:8081

COPY  --from=build /usr/local/app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# When the container starts, replace the env.js with values from environment variables
# CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.sample.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]
 #CMD ["nginx" "-g" "daemon off;"]
CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/env.prep.js > /usr/share/nginx/html/env.js && exec nginx -g 'daemon off;'"]