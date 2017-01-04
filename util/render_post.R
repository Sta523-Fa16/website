#!/usr/bin/env Rscript

library(knitr)
library(rmarkdown)
library(yaml)

args = commandArgs(trailingOnly = TRUE)

input = args[1]
output= args[2]

name = sub(".Rmd$", "", basename(input))
output_dir = paste0(dirname(output),"/")

render(input,
       output_format = html_fragment(),
       output_dir = paste0(output_dir),
       clean = TRUE, quiet = TRUE)

# If front matter exists copy to the new fragment
yaml = rmarkdown:::parse_yaml_front_matter(readLines(input, warn = FALSE))

if (!is.null(yaml))
{
  yaml$output = NULL
  #yaml$reading = NULL
  #yaml$notes = NULL
  #yaml$slides = NULL
  #yaml$link = NULL

  front = as.yaml(yaml)
  front = substr(front,1,nchar(front)-1)

  lines = c("---",
            front,
            "---",
            "", 
            readLines(output, warn = FALSE))

  writeLines(lines, output, useBytes = TRUE)
}
