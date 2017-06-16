HELL=/bin/bash

PANDOC=pandoc
PANDOC_ARGS= --standalone --email-obfuscation=references
PANDOC_INPUT=markdown
PANDOC_OUTPUT=html5

INPUT=index
MARKDOWN_INPUT=$(INPUT).md
HTML_OUTPUT=$(INPUT).html
HTML_TITLE="Curso VMware Workstation"
HTML_CSS_FILE=css/impress.css
HTML_HEADER=_header.html
HTML_BEFORE=_container.html
HTML_FOOTER=_footer.html

build:	clean $(MARKDOWN_INPUT)
	${PANDOC} --from ${PANDOC_INPUT} --to ${PANDOC_OUTPUT} \
	  --section-divs --title-prefix $(HTML_TITLE) --css $(HTML_CSS_FILE) --include-in-header $(HTML_HEADER) --include-before-body $(HTML_BEFORE) --include-after-body $(HTML_FOOTER) \
	  $(PANDOC_ARGS) --output ${HTML_OUTPUT} ${MARKDOWN_INPUT}
	for TEMPLATE in slidy revealjs dzslides ; \
	do \
	  $(PANDOC) --from ${PANDOC_INPUT} --to $$TEMPLATE \
	    --variable=$$TEMPLATE-url:../$$TEMPLATE \
	    $(PANDOC_ARGS) -o $(INPUT).$$TEMPLATE.html $(MARKDOWN_INPUT) ; \
	done
	$(PANDOC) --from ${PANDOC_INPUT} --to s5 \
	  --variable=s5-url:../s5/ui/default \
	  $(PANDOC_ARGS) -o $(INPUT).s5.html $(MARKDOWN_INPUT)

clean:
	rm -v $(INPUT)*.html || true

