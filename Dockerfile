FROM jupyter/pyspark-notebook:latest

USER root

RUN curl -sSL https://install.python-poetry.org | python3 - \
 && ln -s /home/jovyan/.local/bin/poetry /usr/local/bin/poetry
    
ENV PATH="/home/jovyan/.local/bin:$PATH"

WORKDIR /tmp/app

COPY pyproject.toml poetry.lock* ./

RUN poetry config virtualenvs.create false \
 && poetry install --no-interaction --no-ansi --no-root

WORKDIR /home/jovyan/work
COPY . .

RUN chown -R jovyan:users /home/jovyan

USER $NB_UID

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"