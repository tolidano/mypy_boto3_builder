FROM python:3.8.5-alpine3.11

RUN apk add --no-cache gcc libc-dev

RUN mkdir -p /builder/scripts
WORKDIR /builder

ADD ./requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

ADD ./mypy_boto3_builder ./mypy_boto3_builder
ADD ./LICENSE ./LICENSE
ADD ./setup.cfg ./setup.cfg
ADD ./setup.py ./setup.py
ADD ./README.md ./README.md
ADD ./scripts/docker.sh ./scripts/docker.sh
RUN python setup.py install

RUN adduser \
    --disabled-password \
    --home /output \
    builder

USER builder
WORKDIR /output

ENV BOTO3_VERSION ""
ENV BOTOCORE_VERSION ""

ENTRYPOINT ["/builder/scripts/docker.sh"]
