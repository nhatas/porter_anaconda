FROM ubuntu:20.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && \
  apt-get install -y wget bzip2 build-essential \
  ca-certificates git libglib2.0-0 libxext6 libsm6 \
  libxrender1 git mercurial subversion python3-dev && \
  apt-get clean

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  /bin/bash ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh && \
  /opt/conda/bin/conda clean -tipsy && \
  ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
  echo "conda activate base" >> ~/.bashrc && \
  find /opt/conda/ -follow -type f -name '*.a' -delete && \
  find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
  /opt/conda/bin/conda clean -afy

# ENV PATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d/_ppm3d:$PATH
# ENV PATH=/opt/conda/bin:/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d/ppm3d:$PATH
# ENV PYTHONPATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d:$PYTHONPATH
# ENV PYTHONPATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/motifextraction:$PYTHONPATH
# ENV PYTHONPATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d:$PYTHONPATH

ENV PATH=/opt/conda/bin:$PATH
# ENV PATH=/opt/conda/bin:/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/motifextraction:$PATH
# ENV PATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d:$PATH
# ENV LD_LIBRARY_PATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d/_ppm3d:${LD_LIBRARY_PATH}
# ENV PYTHONPATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d:${PYTHONPATH}
# ENV PYTHONPATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/motifextraction:${PYTHONPATH}
# ENV PATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d/_ppm3d:$PATH
# ENV PYTHONPATH=/storage1/fs1/floresk/Active/metallic-glass/motifextraction/packages/ppm3d/_ppm3d:${PYTHONPATH}


COPY environment.yml /var/tmp/environment.yml
RUN conda env update -f /var/tmp/environment.yml && \
  rm -rf /var/tmp/environment.yml

COPY /entrypoint.sh /opt/conda/bin/entrypoint.sh
RUN chmod a+x /opt/conda/bin/entrypoint.sh

#ENTRYPOINT ["/opt/conda/bin/entrypoint.sh"]
CMD [".", "/opt/conda/bin/entrypoint.sh"]