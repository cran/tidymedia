## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(tidymedia)

## -----------------------------------------------------------------------------
folder <- system.file("extdata", package = "tidymedia")
video <- system.file("extdata", "sample.mp4", package = "tidymedia")

## -----------------------------------------------------------------------------
jobs <- ffm_jobs(folder, type = "video")
jobs$output <- paste0(tools::file_path_sans_ext(basename(jobs$input)), ".mp3")

ffm_batch(jobs, run = FALSE, .f = function(input, output, ...) {
  ffm_files(input, output) |>
    ffm_drop("video") |>
    ffm_codec(audio = "libmp3lame")
})

## -----------------------------------------------------------------------------
jobs <- ffm_jobs(folder, type = "video")
jobs$output <- paste0(tools::file_path_sans_ext(basename(jobs$input)), "_cropped.mp4")

crop_video_batch(jobs, width = 160, height = 120, run = FALSE)

## -----------------------------------------------------------------------------
segment_video(
  video,
  start = c(0, 0.5),
  end  = c(0.5, 1),
  run = FALSE
)

## -----------------------------------------------------------------------------
separate_audio_video(video, "audio.aac", "video.mp4", run = FALSE)

## ----eval = FALSE-------------------------------------------------------------
# library(future)
# plan(multisession)
# 
# ffm_batch(jobs, parallel = TRUE, .f = function(input, output, ...) {
#   ffm_files(input, output) |> ffm_drop("video") |> ffm_codec(audio = "libmp3lame")
# })

