FROM alpine

# Install dependencies
RUN apk add \
      streamlink \
      ffmpeg \
      bash

WORKDIR /app

COPY record.sh /app/record.sh
RUN chmod +x /app/record.sh

ENTRYPOINT ["/app/record.sh"]
