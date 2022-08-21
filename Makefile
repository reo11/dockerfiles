FAISS_IMAGE := bluexleoxgreen:latest

faiss: run-faiss

build-faiss:
	docker build -t $(FAISS_IMAGE) -f faiss/faiss.dockerfile .

run-faiss: build-faiss
	docker run --gpus all --rm -it -v ${PWD}/faiss:/var/www/app $(FAISS_IMAGE)