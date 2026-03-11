FROM postgres:16

ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=postgres

WORKDIR /benchmark

COPY schema ./schema
COPY data ./data
COPY tests ./tests
COPY run.sh ./run.sh

RUN chmod +x run.sh

CMD ["bash", "./run.sh"]