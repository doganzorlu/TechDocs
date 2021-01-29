FROM node:13.12.0-alpine
LABEL maintainer="doganzorlu@doganzorlu.com"
ENV PATH /app/node_modules/.bin:$PATH
EXPOSE 80
RUN mkdir -p /app
ADD ./app /app
WORKDIR /app
RUN npm install --silent 
RUN npm install react-scripts@3.4.1 -g --silent
CMD ["npm", "start"]