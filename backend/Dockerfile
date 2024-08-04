#FROM ubuntu:latest
FROM openjdk:22-jdk
LABEL authors="shyam"

#ENTRYPOINT ["top", "-b"]

ADD target/movie-watchlist.jar movie-watchlist.jar
ENTRYPOINT ["java", "-jar", "/movie-watchlist.jar"]
