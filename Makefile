.PHONY: docs style

docs:
	make style
	R -e "devtools::document()"
	R -e "devtools::build_readme()"

style:
	R -e "styler::style_dir(filetype = c('r', 'rmd'))"
