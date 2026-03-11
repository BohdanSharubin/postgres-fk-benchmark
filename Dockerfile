FROM postgres:16

WORKDIR /benchmark

COPY schema ./schema
COPY data ./data
COPY tests ./tests
COPY run.sh ./run.sh

RUN chmod +x run.sh

CMD ["bash", "./run.sh"]