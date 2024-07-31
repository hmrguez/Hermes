# Variables
TYPST_FILES := $(shell find docs -name '*.typ')
PDF_FILES := $(patsubst %.typ,%.pdf,$(TYPST_FILES))

# Default rule
all: $(PDF_FILES)

# Rule to convert Typst to PDF
%.pdf: %.typ
	@typst compile $<

# Rule to watch Typst file
watch:
	@typst watch $(filter-out $@,$(MAKECMDGOALS))

# Rule to clean up
clean:
	@rm -f $(PDF_FILES)

flink:
	cd src/FlinkProcessor && mvn clean package && flink run target/StreamProcessor-1.0-SNAPSHOT.jar