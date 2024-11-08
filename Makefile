GO_MODULE := github.com/TeamKweku/code-odessey-hex-arch-proto

.PHONY: all
all: build

.PHONY: clean
clean:
ifeq ($(OS), Windows_NT)
	if exist "protogen" rd /s /q protogen
	mkdir protogen\go
else
	rm -fR ./protogen 
	mkdir -p ./protogen/go
endif

.PHONY: protoc-go
protoc-go: clean
	protoc --go_opt=module=${GO_MODULE} --go_out=./protogen/go \
	--go-grpc_opt=module=${GO_MODULE} --go-grpc_out=./protogen/go \
	./proto/user/*.proto ./proto/session/*.proto

.PHONY: build
build: clean protoc-go

.PHONY: pipeline-init
pipeline-init:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

.PHONY: pipeline-build
pipeline-build: pipeline-init build

# Add this new target
.PHONY: test
test:
	go test ./... -v
