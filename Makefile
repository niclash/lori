config ?= release

BUILD_DIR ?= build/$(config)
SRC_DIR ?= lori
tests_binary := $(BUILD_DIR)/lori

ifdef config
	ifeq (,$(filter $(config),debug release))
		$(error Unknown configuration "$(config)")
	endif
endif

ifeq ($(config),release)
	PONYC = ponyc
else
	PONYC = ponyc --debug
endif

SOURCE_FILES := $(shell find $(SRC_DIR) -path $(SRC_DIR) -prune -o -name \*.pony)

test: $(tests_binary)
	$^ --exclude=integration --sequential

$(tests_binary): $(GEN_FILES) $(SOURCE_FILES) | $(BUILD_DIR)
	${PONYC} -o ${BUILD_DIR} $(SRC_DIR)

clean:
	rm -rf $(BUILD_DIR)

realclean:
	rm -rf build

TAGS:
	ctags --recurse=yes $(SRC_DIR)

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean realclean TAGS test
