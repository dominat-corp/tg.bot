GOARCH=amd64
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
LDFLAGS=-ldflags "-X main.COMMIT=${COMMIT} -X main.BRANCH=${BRANCH}"
BINARY=tgbot
BUILDDIR=artifact

all: clean pre docker

pre:
	go get -v -d ./...
	
docker:
	CGO_ENABLED=0 GOOS=linux GOARCH=${GOARCH} go build ${LDFLAGS} -a -installsuffix cgo -o ${BUILDDIR}/${BINARY}-${BRANCH}
	
clean:
	rm -f ${BUILDDIR}/${BINARY}-*