# develop stage
FROM node:alpine as develop-stage
RUN ls -la
RUN npm install -g @vue/cli
RUN vue create hellovue
RUN cd hellovue
RUN ls -la
WORKDIR /hellovue
RUN echo "pwd : $PWD"
RUN ls -la
COPY /package*.json ./

COPY . .

# build stage
FROM develop-stage as build-stage
RUN npm run build

# production stage
FROM nginx:alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 90
CMD ["nginx", "-g", "daemon off;"]
