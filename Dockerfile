FROM python:latest as builder
RUN echo "Here we going to install libarys for the application"
WORKDIR /srcode
COPY ./test ./test
COPY ./srcode/* ./

FROM alpine:latest as unittest
WORKDIR /unittest
COPY --from=builder /srcode/test ./test
RUN echo "TODO UNIT TEST" > ./test

FROM alpine:latest as sonarsecurity
WORKDIR /sonar
COPY --from=builder /srcode/* ./
COPY --from=unittest /unittest/test ./test
RUN echo "TODO SONAR TEST" >> ./test

FROM reports:1 as emailreports
WORKDIR /report
COPY --from=sonarsecurity /sonar/test ./test

FROM alpine:latest as myapp
WORKDIR /code
COPY --from=builder /srcode/*.py ./
