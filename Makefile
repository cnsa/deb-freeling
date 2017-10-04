VERSION?=latest

all: clean download release check copy clean clean_image

download:
	./download.sh

release:
	./release.sh

copy:
	./copy.sh

check:
	./check.sh

clean:
	./clean.sh

clean_image:
	./clean_image.sh
