# Multi-step Docker file. First section is the "build" phase.
FROM node:alpine as builder
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
COPY --from=builder /app/build  /usr/share/nginx/html

# base image has a default command to start ngnix, so we don't
# need to specify one!
