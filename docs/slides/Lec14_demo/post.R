library(httr2)

library(job)
empty({
  library(plumber)
  plumb(file='plumber.R')$run(port=4443)
})

request("http://127.0.0.1:4443") |>
  req_url_path("/data/new") |>
  req_method("post") |>
  req_body_json(
    tibble::tibble(
      x = rnorm(30),
      y = rnorm(30),
      group = "9",
      rand = "9"
    )
  ) |>
  req_perform()


last_response() |> 
  resp_body_string() |> 
  cat()