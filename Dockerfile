# develop stage
FROM node:alpine as develop-stage
ENV NODE_VERSION 14.19.3
RUN echo "pwd : $PWD"
RUN ls -la
RUN npm cache clean -f
RUN npm install -g npm@8.11.0 #fix 
RUN npm install -g @vue/cli
RUN vue create -p "Default (Vue 3)" hellovue 
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
