# Use Amazon Linux 2 as the base image
FROM amazonlinux:2

# Set environment variables for Hadoop
ENV HADOOP_VERSION=3.3.1
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin

# Install necessary packages
RUN yum update -y && \
    yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel wget

# Download and extract Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -P /tmp && \
    tar -xzvf /tmp/hadoop-$HADOOP_VERSION.tar.gz -C /opt && \
    ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop

# Configure Hadoop
RUN mkdir -p $HADOOP_HOME/logs

COPY core-site.xml $HADOOP_HOME/etc/hadoop/
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/

# Format HDFS NameNode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# Expose NameNode ports
EXPOSE 9090 9090

# Set the entrypoint
ENTRYPOINT ["hdfs", "namenode"]

# Command to run
CMD ["-d"]

