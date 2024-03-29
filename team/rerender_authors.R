paths <- list.files("_openpipeline/src/authors", pattern = ".yaml", full.names = TRUE, recursive = TRUE)
authors <- lapply(paths, yaml::read_yaml)

for (author in authors) {
  author_id <- gsub("[^a-z_]", "", gsub(" ", "_", tolower(author$name)))
  
  out_path <- paste0("team/", author_id, "/index.qmd")
  out_dir <- dirname(out_path)
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = TRUE)
  }

  # try to assign an image for the author
  #   - if available, use github image
  #   - else if available, use gravatar
  #   - otherwise, use a default
  out_image <- 
    if (!is.null(author$info$links$github)) {
      paste0("https://www.github.com/", author$info$links$github, ".png")
    } else if (!is.null(author$info$links$email)) {
      email_clean <- tolower(stringr::str_trim(author$info$links$email))
      checksum <- digest::digest(email_clean, algo = "md5", serialize = FALSE)
      paste0("https://www.gravatar.com/avatar/", checksum)
    } else {
      "/images/avatar.svg"
    }
  
  # process links
  process_links <- list(
    email = function(value) {
      list(
        icon = "bi-envelope",
        text = "E-mail",
        href = paste0("mailto:", value)
      )
    },
    github = function(value) {
      list(
        icon = "bi-github",
        text = "GitHub",
        href = paste0("https://github.com/", value)
      )
    },
    orcid = function(value) {
      list(
        icon = "fa-brands fa-orcid",
        text = "ORCID",
        href = paste0("https://orcid.org/", value)
      )
    },
    linkedin = function(value) {
      list(
        icon = "bi-linkedin",
        text = "LinkedIn",
        href = paste0("https://www.linkedin.com/in/", value)
      )
    }
  )
  out_links <- list()
  for (link_name in names(author$info$links)) {
    if (link_name %in% names(process_links)) {
      link_info <- process_links[[link_name]](author$info$links[[link_name]])
      out_links <- c(out_links, list(link_info))
    }
  }

  out <- list(
    title = author$name,
    image = out_image,
    role = author$info$role,
    organizations = author$info$organizations,
    links = out_links,
    about = list(
      template = "jolla"
    )
  )
  txt <- paste0("---\n", yaml::as.yaml(out), "---\n")

  writeLines(txt, out_path)
}