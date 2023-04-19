FROM rocker/shiny-verse:latest

WORKDIR /code

# Cache doesn't help for single-use containers (and huggingface
# spaces don't let us write to renv's default cache path)
ENV RENV_CONFIG_CACHE_ENABLED=FALSE

RUN R --quiet -e "install.packages('renv'); renv::init()"

COPY ./renv.lock /code/renv.lock

RUN R --quiet -e "renv::restore()"
RUN ls

COPY . .

CMD ["R", "--quiet", "-e", "shiny::runApp(host='0.0.0.0', port=7860)"]
