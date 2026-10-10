## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
# The chunks below check and produce real files, which means starting FFmpeg or
# FFprobe. Each is evaluated only when the program it needs is installed, so
# this vignette builds on machines and CI images that have neither.
has_ffmpeg <- nzchar(Sys.which("ffmpeg"))
has_ffprobe <- nzchar(Sys.which("ffprobe"))
has_both <- has_ffmpeg && has_ffprobe
# Recorded on stderr rather than into the page: this line is what a build log
# shows for the three programs, so a build that was meant to run without them
# can be checked rather than assumed. `message()` would be captured by knitr and
# then dropped with the rest of this chunk's output.
writeLines(
  paste0("tidymedia vignette build, Sys.which(): ", paste0(
    c("ffmpeg", "ffprobe", "mediainfo"), "=[",
    Sys.which(c("ffmpeg", "ffprobe", "mediainfo")), "]", collapse = " ")),
  con = stderr()
)
# Work in a temporary directory: nothing is written beside the vignette sources,
# and the paths in the reports below stay short enough to read.
knitr::opts_knit$set(root.dir = tempdir())

## ----setup--------------------------------------------------------------------
library(tidymedia)

## -----------------------------------------------------------------------------
file.copy(
  system.file("extdata", "sample.mp4", package = "tidymedia"),
  "session01.mp4"
)

## ----eval = has_both----------------------------------------------------------
extract_audio("session01.mp4", "session01.m4a")

verify_media("session01.m4a", audio_codec = "aac", duration = 1)

## ----eval = has_ffprobe-------------------------------------------------------
verify_media("session01.mp4", duration = 5, width = 1920, audio_codec = "aac")

## ----eval = has_ffprobe-------------------------------------------------------
verify_media("session01.mp4", pix_fmt = "yuv420p", nb_streams = 2)

## ----eval = has_both----------------------------------------------------------
verify_media("session01.m4a", width = 320, audio_codec = "aac")

## ----eval = has_both----------------------------------------------------------
jobs <- tibble::tibble(
  input  = "session01.mp4",
  output = "session01.mp3"
)

ffm_batch(
  jobs,
  verify = list(audio_codec = "mp3"),
  .f = function(input, output, ...) {
    ffm_files(input, output) |>
      ffm_drop("video") |>
      ffm_codec(audio = "libmp3lame")
  }
)

## ----eval = has_both----------------------------------------------------------
res <- ffm_batch(
  jobs,
  manifest = TRUE,
  .f = function(input, output, ...) {
    ffm_files(input, output) |>
      ffm_drop("video") |>
      ffm_codec(audio = "libmp3lame")
  }
)

res

ffm_manifest(res)

## ----eval = has_both----------------------------------------------------------
res <- ffm_batch(
  jobs,
  manifest = TRUE,
  checksums = TRUE,
  .f = function(input, output, ...) {
    ffm_files(input, output) |>
      ffm_drop("video") |>
      ffm_codec(audio = "libmp3lame")
  }
)

ffm_manifest(res)[, c("input_md5", "output_md5")]

## ----eval = has_both----------------------------------------------------------
ffm_manifest(res, path = "session01_manifest.csv")

file.exists("session01_manifest.csv")

## ----eval = has_both, error = TRUE--------------------------------------------
try({
compiled <- ffm_batch(jobs, run = FALSE, manifest = TRUE, .f = function(input, output, ...) {
  ffm_files(input, output) |> ffm_drop("video")
})

ffm_manifest(compiled)
})

## ----eval = FALSE-------------------------------------------------------------
# options(tidymedia.timeout = 600)

## ----eval = has_both----------------------------------------------------------
with_timeout(
  extract_audio("session01.mp4", "bounded.m4a"),
  seconds = 60
)

getOption("tidymedia.timeout")

## ----eval = has_both----------------------------------------------------------
convert_all <- function(files) {
  local_timeout(60)
  vapply(files, function(f) extract_audio(f, sub("[.]mp4$", ".m4a", f)),
         character(1))
}

convert_all("session01.mp4")

getOption("tidymedia.timeout")

## ----error = TRUE-------------------------------------------------------------
try({
with_timeout(extract_audio("session01.mp4", "x.m4a"), seconds = 0.5)
})

