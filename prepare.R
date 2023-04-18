capitalize <- function(str) {
  sub("^.", toupper(substr(str, 1, 1)), str)
}

renamer <- function(name) {
  parts <- strsplit(name, "_", fixed = TRUE)[[1]]
  units <- NULL
  
  if (length(parts) > 1 && tail(parts, 1) %in% c("mm", "g")) {
    units <- paste0(" (", tail(parts, 1), ")")
    parts <- head(parts, -1)
  }
  
  parts <- vapply(parts, capitalize, character(1))
  paste0(paste(parts, collapse = " "), units)
}

rename_all <- function(names) {
  vapply(names, renamer, character(1))
}

palmerpenguins::penguins |>
  dplyr::rename_with(rename_all) |>
  readr::write_csv("penguins.csv")
