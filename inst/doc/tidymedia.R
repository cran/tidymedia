## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
# Work in a temporary directory: the chunks below write real files, and none of
# them belongs beside the vignette sources (verification.Rmd:33 set this).
knitr::opts_knit$set(root.dir = tempdir())

## ----setup--------------------------------------------------------------------
library(tidymedia)

## -----------------------------------------------------------------------------
video <- system.file("extdata", "sample.mp4", package = "tidymedia")

## ----eval = nzchar(Sys.which("ffmpeg")) && nzchar(Sys.which("ffprobe"))-------
extract_audio(video, "audio.m4a")

## -----------------------------------------------------------------------------
extract_audio(video, "audio.m4a", run = FALSE)

## -----------------------------------------------------------------------------
crop_video(video, "cropped.mp4", width = 160, height = 120, run = FALSE)

## -----------------------------------------------------------------------------
extract_audio(video, "lapel.m4a", audio_stream = 1, run = FALSE)

## -----------------------------------------------------------------------------
crop_video(video, "cropped.mp4", width = 160, height = 120, run = FALSE)

## -----------------------------------------------------------------------------
ffm_files(video, "output.mp4") |>
  ffm_trim(start = 1, end = 5) |>
  ffm_crop(width = 160, height = 120) |>
  ffm_codec(video = "libx264") |>
  ffm_compile()

## -----------------------------------------------------------------------------
ffm_files(video, "output.mp4") |>
  ffm_scale(width = 320, height = 240) |>
  ffm_pixel_format("yuv420p")

## -----------------------------------------------------------------------------
ffm_files(video, "boxed.mp4") |>
  ffm_fps(15) |>
  ffm_drawbox(x = 10, y = 10, width = 60, height = 40, color = "black") |>
  ffm_compile()

## -----------------------------------------------------------------------------
ffm_files(video, "speech.m4a") |>
  ffm_drop("video") |>
  ffm_loudnorm(target_loudness = -23, true_peak = -1) |>
  ffm_compile()

## -----------------------------------------------------------------------------
ffm_files(video, "web.mp4") |>
  ffm_output_options("-movflags +faststart") |>
  ffm_compile()

## -----------------------------------------------------------------------------
# Fast cut with no loss of quality
ffm_files(video, "output.mp4") |>
  ffm_seek(start = 1, end = 5, reencode = FALSE) |>
  ffm_copy() |>
  ffm_compile()

## -----------------------------------------------------------------------------
ffm_files(c(video, video), "side_by_side.mp4") |>
  ffm_hstack() |>
  ffm_compile()

## -----------------------------------------------------------------------------
compare_videos(c(video, video), "compare.mp4", audio_input = 0, run = FALSE)

## ----eval = nzchar(Sys.which("ffmpeg"))---------------------------------------
# Your own arguments, passed to FFmpeg as they are
ffmpeg("-version")[1]

