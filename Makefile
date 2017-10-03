VERSION?=latest

all: release

download:
	curl -o ./packages/FreeLing-4.0.tar.gz -L https://github.com/TALP-UPC/FreeLing/releases/download/4.0/FreeLing-4.0.tar.gz

release:
	./release.sh
