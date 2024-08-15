GO_MODULE_USER := github.com/teamkweku/code-odessey-hex-arch-proto

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
protoc-go:
	protoc --experimental_allow_proto3_optional \
	--go_opt=module=${GO_MODULE_USER} --go_out=. \
	--go-grpc_opt=module=${GO_MODULE_USER} --go-grpc_out=. \
	./proto/user/*.proto

.PHONY: build
build: clean protoc-go

.PHONY: pipeline-init
pipeline-init:
	sudo apt-get install -y protobuf-compiler golang-goprotobuf-dev
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

.PHONY: pipeline-build
pipeline-build: pipeline-init build
