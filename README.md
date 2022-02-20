
docker build . --tag grpc:latest
docker tag grpc:latest gcr.io/$GOOGLE_CLOUD_PROJECT/grpc:latest
docker push gcr.io/$GOOGLE_CLOUD_PROJECT/grpc:latest
