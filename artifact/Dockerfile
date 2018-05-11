FROM alpine

RUN mkdir /app
COPY ./artifact /app
WORKDIR /app

EXPOSE 8988

CMD [ "./tgbot-master" ]