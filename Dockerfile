# 노드 버전
FROM node:20-alpine

# 컨테이너 내부 작업 디렉터리로 이동
WORKDIR /app

# 컨테이너 내부로 의존성 파일 복사 (수정 빈도가 적을수록 위에 기재)
COPY package*.json ./

# install은 의존성에 같은 버전이라도 가장 최신 버전을 설치하지만 ci는 package-lock에 기재돼있는 동일한 버전으로 설치
# RUN npm install
RUN npm ci

# 호스트 머신의 현재 디렉터리 파일들을 컨테이너 내부로 전부 복사
COPY . .

# 마지막으로 cli에 입력돼서 실행되는 것들 (Ex. $ node index.js)
ENTRYPOINT [ "node", "src/index.js" ]

# 도커 이미지 생성 CLI (참고: https://docs.docker.com/engine/reference/commandline/build)
# docker build -f Dockerfile -t [image name] .
# - f: 도커 빌드 파일 명시 (Dockerfile)
# - t: 도커 이미지명
# - .: 도커가 빌드할 원본 파일들 위치 (최상위)

# 도커 이미지 실행 CLI
# docker run -d -p 8080:8080 [image name]
# - d: 도커 빌드 후 도커 실행 (background)
# - p: host port(8080), container port(8080) 매핑

# 도커 이미지 제거 CLI
# docker rmi [image name]

# 도커 이미지 리스트 CLI
# docker images

# 도커 제거 CLI
# docker rm $(docker ps -a -q)

# 도커 실행중 이미지 리스트 CLI
# docker ps

# 도커 실행중 이미지 제거 CLI
# docker kill $(docker ps -q)

# 도커 푸시 CLI
# docker push [도커 계정]/[이미지명 혹은 레포지토리명]:[태그]
# Ex. docker push withbbang/docker-tutorial:latest
# 참고: withbbang/docker-tutorial:latest와 동일한 이미지를 생성해야한다. -> docker tag docker-tutorial:latest withbbang/docker-tutorial:latest

# 도커 이미지 빌드 부터 푸시까지 순서
# 1. Dockerfile 만들기
# 2. docker build -f Dockerfile -t [image name] .
# rf) Mac 칩에서는 cpu 칩 호환 문제로 다르게 빌드해야한다.
# rf) docker buildx build --platform=linux/amd64,linux/arm64 -f Dockerfile -t [image name] .
# 3. docker hub에서 레포지토리 만들기
# 4. docker tag [이미지명]:[태그] [도커 계정]/[이미지명 혹은 레포지토리명]:[태그]
# 5. docker push [도커 계정]/[이미지명 혹은 레포지토리명]:[태그]