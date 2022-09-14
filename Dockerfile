FROM condaforge/mambaforge AS build


ARG VERSION
ENV version=$VERSION

COPY environment.yml /my-model/environment.yml

RUN conda install -c conda-forge conda-pack && \
  conda env create -f /$my-model/environment.yml

# Use conda-pack to create a  enviornment in /venv:
RUN conda-pack -n my-model -o /tmp/env.tar && \
  mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
  rm /tmp/env.tar

# Fix paths, will be same in final image so this is fine
RUN /venv/bin/conda-unpack

# No longer need conda, just the packed python
FROM debian:buster AS runtime

# Copy /venv from the previous stage:
COPY --from=build /venv /venv
COPY . /$my-model

COPY _entrypoint.sh /usr/local/bin/_entrypoint.sh
COPY my_model/flow.py /opt/prefect/flow.py

RUN chmod +x /usr/local/bin/_entrypoint.sh
RUN mkdir /opt/prefect

RUN source /venv/bin/activate && \
  python -m pip install /my-model

# When image is run, run the code with the environment
# activated:
SHELL ["/usr/local/bin/_entrypoint.sh", "/bin/bash", "-c"]

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]