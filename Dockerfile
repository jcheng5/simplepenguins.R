FROM rocker/shiny-verse:latest

WORKDIR /code

RUN R --quiet -e "install.packages('renv'); renv::init()"

COPY ./renv.lock /code/renv.lock

RUN R --quiet -e "renv::restore()"
RUN ls

COPY . .

CMD ["R", "--quiet", "-e", "shiny::runApp(host='0.0.0.0', port=7860)"]
