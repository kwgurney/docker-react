# Multi-step Docker file. First section is the "build" phase.
# EBeanStalk does not like this:
#FROM node:alpine as builder
# So have to use "unnamed builder". From docker docs:
# "By default, the stages are not named, and you refer to them by their integer number, starting with 0 for the first FROM instruction."
FROM node:alpine
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Second section is the prod server.
# (Don't have to label it with "as". Previous block ("builder") is done now.)
FROM nginx
# "docker run -p 80:80"
EXPOSE 80

# NOTE: /app/build in the container is the stuff we want
COPY --from=0 /app/build  /usr/share/nginx/html

# base image has a default command to start ngnix, so we don't
# need to specify one!
