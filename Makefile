GOARCH=amd64
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
LDFLAGS=-ldflags "-X main.COMMIT=${COMMIT} -X main.BRANCH=${BRANCH}"
BINARY=tgbot
BUILDDIR=artifact

all: clean pre linux

pre:
	godep get
	
linux:
	GOOS=linux GOARCH=${GOARCH} go build ${LDFLAGS} -o ${BUILDDIR}/${BINARY}-${BRANCH}

clean:
	rm -f ${BUILDDIR}/${BINARY}-*