## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
# Metadata readers shell out to FFprobe / MediaInfo. Chunks that need a binary
# are evaluated only when it is available, so this vignette builds cleanly on
# machines (and CI images) that lack the command-line tools.
has_ffprobe <- nzchar(Sys.which("ffprobe"))
has_mediainfo <- nzchar(Sys.which("mediainfo"))

## ----setup--------------------------------------------------------------------
library(tidymedia)

## -----------------------------------------------------------------------------
video <- system.file("extdata", "sample.mp4", package = "tidymedia")

## ----eval = has_ffprobe-------------------------------------------------------
info <- probe_all(video)
info$container

## ----eval = has_ffprobe-------------------------------------------------------
info$streams

## ----eval = has_ffprobe-------------------------------------------------------
# Use the probe result, so the file is not read again
probe_video(info)

## ----eval = has_mediainfo-----------------------------------------------------
mediainfo_query(
  video,
  section = "Video",
  parameters = c("Width", "Height", "FrameRate")
)

## ----eval = has_mediainfo-----------------------------------------------------
mediainfo_template(video, template = "brief")

## ----eval = has_mediainfo-----------------------------------------------------
get_duration(video, unit = "sec")
get_width(video)
get_height(video)

## ----eval = FALSE-------------------------------------------------------------
# files <- ffm_jobs("my/videos", type = "video")$input
# probe_all(files)$container

## ----eval = FALSE-------------------------------------------------------------
# probe_all(files, parallel = TRUE)$container

