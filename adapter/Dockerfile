FROM node:6

COPY package.json /opt/gfcc/broker_test_adapter/package.json
RUN cd /opt/gfcc/broker_test_adapter && npm install

# add rest of source
COPY . /opt/gfcc/broker_test_adapter

WORKDIR /opt/gfcc/broker_test_adapter
CMD ["npm", "start"]

EXPOSE 8080
USER www-data
