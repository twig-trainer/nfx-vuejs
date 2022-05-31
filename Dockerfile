# develop stage
FROM node:alpine as develop-stage
WORKDIR /app
RUN echo "pwd : $PWD"
RUN alias ls > $DOCKER_GO
RUN echo "ls" >> $DOCKER_GO
RUN echo "ls"
COPY package*.json ./
RUN npm install
COPY . .

# build stage
FROM develop-stage as build-stage
RUN npm run build

# production stage
FROM nginx:alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 90
CMD ["nginx", "-g", "daemon off;"]
