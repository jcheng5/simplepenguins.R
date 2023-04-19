FROM rocker/shiny-verse:latest

WORKDIR /code

RUN install2.r --ncpus 2 --error \
    ggExtra \
    bslib

# RUN installGithub.r \
#     rstudio/shiny \
#     rstudio/httpuv@ping

COPY . .

CMD ["R", "--quiet", "-e", "shiny::runApp(host='0.0.0.0', port=7860)"]
