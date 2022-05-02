`xaringan_cfa` <- function(
  theme = "cfa-a", # length 1 or css (mix themes, test new css, etc.)
  css = NULL, # css <- c("**/cfa-a.css", "**/cfa-b-fonts.css")
  img = NULL,
  js  = NULL,
  asset_dir = "cfa_assets" # quick fix to get css into HTML dependency from custom assets
  ) {
  # check arguments
  if (!is.null(theme) & !is.null(css)) stop("Specify either `theme` or `css`, but not both.")
  quick_fix_dir <- file.path(asset_dir, "css") # sub pkg_resource("css") util

  if (!is.null(theme)) {
    # Check css
    theme.css <- grep(paste(theme, collapse = "|"), list.files(quick_fix_dir), value = TRUE)
    # theme.css <- gsub("[.](?:sa|sc|c)ss$", "", theme.css)

    theme_css <- if (length(theme.css)) {
      # css <- union(css, theme.css)
      # check_builtin_css(css)
      #   list(css_deps(theme.css))
      if (all(theme.css %in% list.files(quick_fix_dir))) {
        htmltools::htmlDependency(
          "css", "0.0.1", quick_fix_dir,
          stylesheet = theme.css,
          all_files = TRUE
        )
      }
    }
  } else {
    # allow user to mix and match cfa theme assets
    css <- gsub("^\\*\\*", quick_fix_dir, css)
    theme_css <- htmltools::htmlDependency(
      "css", "0.0.1", dirname(css),
      stylesheet = basename(css),
      all_files = TRUE
    )
  }

  # quick fix? bug or feature...
  # htmltools::tagList(theme_css)
  # assign to css.cp to suppress output. 
  # Gives warning about directory not existing, but they get copied anyway...
  css.cp <- htmltools::copyDependencyToDir(theme_css, "libs/cfa_assets", mustWork = TRUE)

  #  Images for background and footer - def a cludge...
  if (!is.null(img)) {
    quick_fix_dir <- file.path(asset_dir, "img") # sub pkg_resource("img") util
    theme_img <- htmltools::htmlDependency(
      "img", "0.0.1", quick_fix_dir,
      all_files = TRUE # needs to be TRUE - not sure how to send in a subset of files without <link>ing them in <head>...
    )
    # htmltools::tagList(theme_img)
    img.cp <- htmltools::copyDependencyToDir(theme_img, "libs/cfa_assets", mustWork = TRUE)
  }
}