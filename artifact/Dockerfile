FROM alpine

RUN apk add --no-cache --virtual ca-certificates

RUN mkdir /app
COPY . /app
WORKDIR /app

EXPOSE 8988

CMD [ "./tgbot-master" ]