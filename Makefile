.PHONY: docs style test

docs:
	make style
	R -e "devtools::document()"
	R -e "devtools::build_readme()"

style:
	R -e "styler::style_dir(filetype = c('r', 'rmd'))"

test:
	make docs
	R -e "urlchecker::url_check()"
	R -e "devtools::check(remote = TRUE, manual = TRUE)"
	R -e "devtools::check_win_devel(quiet = TRUE)"
	R -e "devtools::check_win_release(quiet = TRUE)"
	R -e "devtools::check_win_oldrelease(quiet = TRUE)"
	R -e "rhub::check_for_cran()"
	R -e "rhub::check_on_macos()"
