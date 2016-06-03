FROM node:6

COPY package.json /opt/gfcc/broker-adapter/package.json
RUN cd /opt/gfcc/broker-adapter && npm install

# add rest of source
COPY . /opt/gfcc/broker-adapter

WORKDIR /opt/gfcc/broker-adapter
CMD ["npm", "start"]

EXPOSE 8080
USER www-data
