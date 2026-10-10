## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
# The capability chunk in section 1 starts FFmpeg, so it is evaluated only when
# FFmpeg is installed. Every other evaluated chunk uses `run = FALSE` and starts
# nothing.
has_ffmpeg <- nzchar(Sys.which("ffmpeg"))

## ----setup--------------------------------------------------------------------
library(tidymedia)

## -----------------------------------------------------------------------------
session <- system.file("extdata", "sample.mp4", package = "tidymedia")

## ----eval = FALSE-------------------------------------------------------------
# jobs <- ffm_jobs("study/raw", type = "video")
# jobs
# #> # A tibble: 4 × 1
# #>   input
# #>   <chr>
# #> 1 /data/study/raw/session01_camA.mp4
# #> 2 /data/study/raw/session01_camB.mp4
# #> 3 /data/study/raw/session02_camA.mp4
# #> 4 /data/study/raw/session02_camB.mp4

## -----------------------------------------------------------------------------
standardize_video(
  session, "session01_camA_std.mp4",
  width = 1280, height = 720, fps = 30,
  run = FALSE
)

## ----eval = FALSE-------------------------------------------------------------
# jobs$output <- sub("/raw/", "/std/", jobs$input)
# standardize_video_batch(jobs, width = 1280, height = 720, fps = 30)

## ----eval = has_ffmpeg--------------------------------------------------------
head(ffmpeg_codecs())

encoders <- ffmpeg_encoders()
head(encoders[encoders$type == "Video", c("name", "details")])

hardware_encoder("h264", "nvenc")
hardware_encoder("h264", "videotoolbox")
has_hardware_encoder("h264", "videotoolbox")

## ----eval = FALSE-------------------------------------------------------------
# standardize_video_batch(
#   jobs, width = 1280, height = 720, fps = 30,
#   hardware = "videotoolbox"
# )

## ----eval = FALSE-------------------------------------------------------------
# standardize_video("raw.mp4", "std.mp4", hardware = "videotoolbox", quality = 60)

## -----------------------------------------------------------------------------
normalize_audio(session, "session01_camA_norm.wav",
                target_loudness = -23, run = FALSE)

## -----------------------------------------------------------------------------
convert_audio(session, "session01_camA.wav", run = FALSE)

## -----------------------------------------------------------------------------
extract_frame(session, "session01_camA_t30.png", timestamp = 30, run = FALSE)

## ----eval = FALSE-------------------------------------------------------------
# sample_frames("session01_camA_std.mp4", outdir = "frames/session01_camA",
#               fps = 1)

## -----------------------------------------------------------------------------
strip_metadata(session, "session01_camA_clean.mp4", run = FALSE)

## -----------------------------------------------------------------------------
regions <- tibble::tibble(
  x = 16, y = 640, width = 360, height = 64  # lower-left name caption
)
anonymize_video(session, "session01_camA_deid.mp4", regions = regions,
                run = FALSE)

## ----eval = FALSE-------------------------------------------------------------
# concatenate_videos(
#   c("session01_camA_part1.mp4", "session01_camA_part2.mp4"),
#   "session01_camA_full.mp4"
# )

## -----------------------------------------------------------------------------
format_for_web(session, "session01_camA_share.mp4", run = FALSE)

