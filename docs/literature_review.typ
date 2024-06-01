#set page(columns: 2)

= Literature Review

== Introduction

The advent of big data has necessitated the development of architectures capable of efficiently ingesting, processing and analyzing large volumes of data in real time. In this literature review explores two prominent data processing architectures: Lambda and Kappa architectures. We will also cover the evolutions of these architectures and the challenges they face and how some new arising technologies have made their place in specific components of those architectures. Then we will delve into how event driven architectures are changing the way we think about data processing and make an emphasis on existing Complex Event Processing (CEP) frameworks, what they are and how do they orchestrate events in a data processing pipeline. Lastly we will cover the arising of a promising new technology called the StreamCube which leverages both batch and stream processing to provide a new way of querying data.

== General overview

=== What is big data?

Big data is what we call a vast amount of data that can be ingested, processed and stored using conventional techniques. These can come in different forms like social media, sensor information, smart cities, mobile devices telemetry, etc. Characteristics of big data are often described by the three Vs: Volume, Velocity and Variety. Volume refers to the amount of data that is being generated, Velocity refers to the speed at which data is being generated and Variety refers to the different types of data that is being generated. Other Vs have been added to the definition of big data like Veracity and Value. Veracity refers to the quality of the data and Value refers to the insights that can be extracted from the data.

=== ETL

ETL, standing for Extract, Transform, and Load, is a fundamental process in data warehousing and data integration. It
involves extracting data from various sources, transforming it into a standardized format, and then loading it into a
data warehouse or another target system for analysis, reporting, and data-driven decision-making. @big-archive

The initial step in the ETL process involves extracting data from multiple sources. These sources can include
  relational databases, NoSQL databases, flat files, spreadsheets, and web services. The extracted data is typically
  stored in a staging area, which is a temporary location used to hold data before it undergoes transformation

  During the transformation phase, the extracted data is cleaned, validated, and converted into a format that is
    suitable for analysis. This may involve several operations such as filtering, cleaning (handling missing values,
    correcting errors), joining data from multiple sources, splitting attributes, and sorting data. The goal is to ensure
    that the data is accurate, consistent, and in a format that meets the requirements of the data warehouse and the
    analytical queries that will be run against it

    The final step in the ETL process is loading the transformed data into the target system, which is often a data
      warehouse. The data warehouse is designed to consolidate data from various sources into a single, integrated view,
      making it easier to perform complex analyses and generate insightful reports. Loading the data into the warehouse
      involves creating the necessary schemas and tables and inserting the data into these structures



=== Two different ways of processing data

Nowadays there are mainly two ways to process data: batch processing and stream processing. Batch processing is the traditional way of processing data where data is collected over a period of time and then processed in one go in batches which is particularly efficient due to some technologies we will see down further. Stream processing is the new way of processing data where data is processed as it arrives. Depending on the use case, data can become obsolete at different periods of time. It is a general rule of thumb that data that can become obsolete in a short period of time should be processed in real time, while data that can become obsolete in a longer period of time can be processed in batch. Examples of batch processing scenarios can be when extracting data to train a machine learning model, as long as the data is accurate and isn't subject to data drift it will do. Examples of stream data can be vital signs of a hospitalized patient, which needs to be analyzed with the least latency possible as a minimum sidestep can cost the nurses and doctors not responding on time.


=== Lambda Architecture

Proposed by Nathan Marz is a data processing architecture designed to handle massive quantities of data by taking advantage of both batch and stream processing methods. The architecture is composed of three layers: the batch layer, the speed layer, and the serving layer. The batch layer is responsible for storing and processing large amounts of data in a fault-tolerant manner. The speed layer is responsible for processing real-time data and providing up-to-date results. The serving layer is responsible for querying and serving the results of the batch and speed layers. The Lambda Architecture is designed to be fault-tolerant, scalable, and extensible @marz @fundamentals-lambda-kappa

=== Kappa Architecture

Introduced by Jay Kreps, the Kappa architecture simplifies the Lambda model by removing the batch layer, thus relying solely on stream processing. This approach aims to reduce the complexity and latency associated with maintaining separate batch and real-time systems @fundamentals-lambda-kappa.

=== EDA & CEP

EDA (Event Driven Architecture) is a design paradigm where the flow of the program is determined by events such as user actions, sensor outputs, or messages from other programs. In EDA, components produce, detect, consume, and react to events. This architecture supports real-time interactive processing and is highly suitable for scenarios like the Internet of Things (IoT), where devices generate and consume events. The key components of EDA include event producers, event channels, and event consumers. Producers create event messages that flow through channels to consumers, which then take specific actions based on the events. This setup ensures loose coupling between components, allowing for scalability and flexibility. EDA enables disparate applications to interact effectively, facilitating rapid response to both simple and complex event dependencies @cep.

CEP (Complex Event Processing) extends beyond simple event processing by dealing with patterns, combinations, and correlations of events. It involves detecting and managing complex relationships among events, which can be causal, temporal, or spatial. CEP systems analyze real-time data streams to identify meaningful patterns and insights, enabling proactive and timely responses to business opportunities or threats. Unlike simple event processing, CEP considers historical data and aggregations, providing a more comprehensive view of the data. This capability is crucial for industries where real-time decision-making is vital, such as finance, healthcare, and transportation @cep.

=== A new architecture

StreamCube is a novel data processing architecture that combines batch and stream processing to provide a unified approach to querying data. It leverages the strengths of both batch and stream processing to deliver real-time analytics on large-scale datasets. StreamCube is designed to handle complex queries efficiently by partitioning data into cubes and processing them in parallel. This architecture enables users to query data in real time, providing insights into the data as it arrives. @streamcube

== Technologies and frameworks

=== Apache Family

The Apache Software Foundation offers a robust ecosystem of open-source tools designed to address a wide array of big data challenges. This suite, often referred to as the "Apache family," encompasses diverse projects catering to different aspects of data management and processing. At the core, Apache Hadoop provides a scalable framework for distributed storage and processing of large data sets using the MapReduce programming model. Complementing Hadoop are Apache Spark, a fast and general-purpose cluster computing system for real-time data processing, and Apache Flink, known for its efficient stream and batch processing capabilities. These tools are essential for processing massive volumes of data with high performance and reliability.

Beyond core processing frameworks, the Apache family includes a range of specialized software. Apache Cassandra and Apache HBase offer distributed database solutions optimized for handling large-scale, high-velocity data across numerous servers with minimal latency. For real-time data streaming, Apache Kafka is a highly reliable message broker that supports high-throughput and low-latency data feeds. Apache Hive and Apache Pig simplify querying and analyzing large datasets stored in Hadoop. This comprehensive suite is pivotal for organizations aiming to harness big data for insights, driving innovation and operational efficiency. Each tool within the Apache family is designed to integrate seamlessly, providing a cohesive and scalable solution for various big data needs.

=== Apache Hadoop

Apache Hadoop is a powerful framework designed for processing large volumes of data across clusters of computers using
simple programming models. It is built to scale up from single servers to thousands of machines, each offering local
computation and storage. At the heart of Hadoop is the MapReduce programming model, which enables the processing of vast
amounts of data in parallel on large clusters of commodity hardware in a reliable and fault-tolerant manner @hadoop

==== How does MapReduce work?

MapReduce is a software framework for writing applications that process large amounts of data in parallel on large clusters of commodity hardware. It simplifies the process of dealing with large data sets by breaking down the work into smaller tasks that can be executed independently and in parallel. This approach significantly improves efficiency and throughput, especially when dealing with multi-terabyte data sets @hadoop. It works the following way:

- *Input*: A MapReduce job typically starts with a dataset stored in a distributed file system like Hadoop Distributed
  File System (HDFS). The input data is divided into independent chunks, which are processed by the map tasks in
  parallel

- *Map Phase*: The map function processes each chunk of data, transforming the input into a set of intermediate
  key-value pairs. This phase is highly parallelizable, allowing for efficient processing of large datasets

- *Shuffle and Sort*: After the map phase, the intermediate key-value pairs are shuffled and sorted. This step
  organizes the data in a way that is optimal for the reduce phase

- *Reduce Phase*: The reduce function takes the sorted key-value pairs as input and combines them to produce the final
  output. This phase is also parallelized, further enhancing the efficiency of the process

- *Output*: The results of the reduce phase are typically stored back in the distributed file system, ready for
  further processing or analysis

MapReduce is particularly useful when doing batch processing work but not when dealing with streaming data as we will see later

==== Apache Kafka
 Apache Kafka is a distributed data streaming platform designed for real-time data processing. It is optimized for ingesting and processing streaming data, making it suitable for building real-time streaming data pipelines and applications. Kafka's architecture allows it to handle the constant influx of data from thousands of data sources, processing this data sequentially and incrementally. It combines messaging, storage, and stream processing functionalities to enable the storage and analysis of both historical and real-time data @kafka

 Kafka operates on a publish-subscribe model, where data is published to topics and consumed by subscribers. This model facilitates the efficient distribution of data across multiple consumers, ensuring low-latency and high-throughput data processing. Kafka's ability to process data streams in real-time supports continuous data ingestion and real-time analytics, empowering businesses to make timely and data-driven decisions

Key components of Kafka include producers, consumers, topics, and events. Producers are client applications that push events into topics, which are categorized and stored logs holding events in a logical order. Consumers are applications that read and process events from these topics. Events represent records of changes to the system's state, transmitted as part of Kafka's event streaming platform

Kafka's benefits extend beyond its core functionality. It offers faster processing speeds compared to other platforms, enabling near-zero latency real-time data streaming. This capability is crucial for performing real-time data analytics and making quick business decisions. Additionally, Kafka Connect, a component of Apache Kafka, serves as a centralized data hub, facilitating integration between various data systems and accelerating the development of applications. Kafka's scalability and durability ensure that production clusters can be adjusted based on demand, with fault tolerance and intra-cluster replication providing high durability for the data it handles

=== Apache Spark
 Apache Spark is a unified analytics engine designed for large-scale data processing. It is known for its speed, ease of use, and versatility, making it a popular choice for both batch and real-time data processing. Spark's architecture supports a wide range of data processing tasks, including ETL (Extract, Transform, Load), data warehousing, machine learning, and graph processing. It can operate on data stored in various formats and locations, such as HDFS, HBase, Cassandra, and any HDFS-compatible data source @spark

Spark Streaming is a component of Apache Spark that enables real-time data processing. It allows users to process live data streams in real-time, making it suitable for applications that require immediate insights from incoming data. Spark Streaming achieves this by dividing the data stream into micro-batches, processing each micro-batch as a separate RDD (Resilient Distributed Dataset). These RDDs can then be transformed and acted upon using Spark's standard operations, such as map, filter, and reduceByKey

- *Resilient Distributed Datasets (RDDs)*: RDDs are the fundamental data structure of Spark. They are an immutable distributed collection of objects. Each dataset in RDD is divided into logical partitions, which may be computed on different nodes of the cluster. RDDs support two types of operations: transformations, which create a new dataset from an existing one, and actions, which return a value to the driver program after running a computation on the dataset
- *Directed Acyclic Graph (DAG)*: Spark uses a DAG-based approach for executing transformations. The transformations are optimized and executed in stages, where each stage consists of one or more tasks. Tasks are the smallest unit of work sent to executors. Executors run tasks in parallel, taking advantage of the underlying cluster resources efficiently

Spark's architecture includes several components, such as the Driver Program, Cluster Manager, Executor, and Storage Layer. The Driver Program submits tasks to the cluster manager, which schedules them on executor nodes. Executors run tasks and store intermediate data in memory or disk, depending on the configuration. The Storage Layer handles data storage and retrieval, often interfacing with distributed storage systems like HDFS

=== Apache Storm

Apache Storm is a distributed real-time computation system designed to process unbounded streams of data with high throughput and low latency. It is often described as doing for real-time processing what Hadoop did for batch processing, emphasizing its role in enabling real-time analytics, online machine learning, continuous computation, distributed RPC, ETL, and more Storm's architecture and features make it a powerful tool for handling real-time data processing tasks, ensuring that data is processed reliably and efficiently. @storm

Apache Storm is designed for real-time data processing. Its architecture revolves around spouts and bolts, which are the primary components of a Storm topology.

- *Spouts*: These are the sources of data streams in Storm. They ingest data from various sources such as message queues, log files, databases, APIs, or other data producers. Spouts emit data in the form of tuples into the Storm topology for processing 4.

- *Bolts*: Bolts are processing units within a Storm topology. They receive input tuples, perform computations or transformations, and emit output tuples. Bolts can be chained together to create complex processing pipelines 4.

These components work together to enable real-time data processing in Storm. The output of a spout is connected to the input of bolts, and the output of a bolt is connected to the input of other bolts, forming a directed acyclic graph (DAG) that defines the flow of data through the topology

==== Apache Flink

Apache Flink is a powerful, open-source framework and distributed processing engine designed for stateful computations over unbounded and bounded data streams. It stands out for its ability to perform computations at in-memory speeds and at any scale, making it suitable for a wide range of applications from real-time analytics to complex event processing. @flink

It is built around the concept of DataStream API, which allows users to define and execute data processing pipelines on streaming data. Flink's architecture supports both batch and stream processing, enabling users to seamlessly switch between the two modes. This flexibility is particularly useful for applications that require both real-time and batch processing capabilities.

Flink's architecture is designed to efficiently scale and process large datasets in near real-time, providing fault tolerance and enabling job restarts with minimal data loss. It operates on a master/slave model with two key components:

- *JobManager*: Responsible for scheduling and managing the jobs submitted to Flink, orchestrating the execution plan by allocating resources for tasks.
- *TaskManagers*: Execute user-defined functions on allocated resources across multiple nodes in a cluster, handling the actual computation tasks.

_Addemdum_: Flink also supports CEP technology through its CEP module but we will not discuss it here

=== Apache Cassandra

Apache Cassandra is a highly scalable, high-performance distributed database designed to handle large amounts of data across many commodity servers, providing high availability with no single point of failure. It is often used in scenarios requiring real-time data processing and batch processing due to its ability to handle high write loads and provide fast read latencies. Let's explore how Cassandra can be utilized for both real-time and batch processing scenarios. @cassandra

Cassandra is well-suited for real-time data processing, especially when dealing with high-volume transactions. Its design emphasizes high availability, partition tolerance, and eventual consistency, making it an excellent choice for applications that require consistent performance under heavy load. For real-time applications, such as feature stores, Cassandra can serve features with a typical p99 latency of less than 23 milliseconds, as demonstrated by its use by companies like Uber and Netflix

Cassandra's ability to handle high write loads with minimal impact on read latency makes it ideal for scenarios where data needs to be updated frequently and accessed quickly. This characteristic is particularly beneficial for real-time feature stores, where features are computed in real-time and then potentially recomputed in batch, with discrepancies updated in both the real-time and batch systems

While Cassandra shines in real-time scenarios, it also supports batch processing through its support for Hadoop, allowing it to integrate with Hadoop-based batch processing jobs. This integration enables the use of Cassandra as a data store for batch processing tasks, such as data aggregation and analysis, by leveraging Hadoop's MapReduce framework

=== Apache Flume

Apache Flume is a distributed, reliable, and available system designed for efficiently collecting, aggregating, and moving large volumes of streaming data. Originated at Cloudera and now developed by the Apache Software Foundation, Flume is widely used in big data environments for ingesting log files, social media data, clickstreams, and other high-volume data sources. Its primary purpose is to simplify the data ingestion process, ensuring reliable delivery and fault tolerance in distributed systems. Flume supports data ingestion from various sources, including web servers, databases, and application logs, and facilitates data flow to a distributed filesystem or data lake where it can be analyzed by data processing frameworks like Apache Hadoop and Apache Spark @flume

Flume operates on a modular design with customizable components, enabling flexible and scalable architectures. It is particularly well-suited for collecting log files from different sources such as web servers, application servers, and network devices, and then transporting them to centralized storage or analytics systems. This makes it an essential tool for big data analytics, enabling organizations to analyze vast amounts of data efficiently

Flume's architecture is based on streaming data flows, making it robust and fault-tolerant with tunable reliability mechanisms and numerous failover and recovery options. It employs a simple yet extensible data model that supports online analytical applications, further enhancing its utility in data-driven decision-making processes

=== MongoDB

MongoDB is a highly versatile, open-source NoSQL database that excels in big data processing due to its unique features and architecture. It is designed to handle high volumes of data with ease, offering high performance, availability, and scalability.

MongoDB is engineered to deliver high performance and scalability, making it suitable for big data processing. It can easily scale out to accommodate growing data volumes and user loads.

Unlike traditional relational databases, MongoDB stores data in BSON (Binary JSON) format, which allows for flexible, schema-less data models. This flexibility is particularly beneficial for handling varied data types and structures common in big data scenarios.

MongoDB supports real-time data processing through its aggregation pipeline framework and integration with tools like Kafka and Spark. This enables efficient ingestion and processing of data as it arrives, making it ideal for applications requiring immediate insights from data streams.

MongoDB can integrate with the Hadoop ecosystem, allowing for the processing of large datasets using MapReduce and other big data processing tools. This integration facilitates the analysis of big data across MongoDB and Hadoop platforms.

MongoDB employs sharding to distribute data across multiple servers, enabling horizontal scaling. Sharding allows MongoDB to handle large volumes of data by distributing the load across a cluster of servers, improving performance and availability.

=== Esper

Esper is an open-source CEP engine that allows for the creation of complex event queries using a SQL-like syntax. Esper is designed to run on a single machine, making it suitable for lightweight applications or development environments. @esper

Esper operates by continuously searching through incoming event streams for predefined patterns. When a match is found, it generates a "complex event," which can trigger alerts, notifications, or further actions based on the defined logic. This makes Esper highly versatile for applications ranging from fraud detection to monitoring manufacturing processes.

Esper's architecture is designed around the concept of event processing, where events are ingested from various sources, processed according to user-defined rules, and then either acted upon or stored for later analysis. The core components of Esper's architecture include:

- *Event Input*: Events can be sourced from a variety of locations, including databases, file systems, or direct feeds from external systems.
- *Rule Engine*: At the heart of Esper, the rule engine evaluates incoming events against a set of predefined rules. These rules specify the conditions under which a complex event should be generated.
- *Output Actions*: Once a complex event is detected, Esper can perform a variety of actions, such as sending notifications, triggering alerts, or invoking external systems to take corrective action.
- *Storage*: For historical analysis or debugging purposes, Esper can store processed events and complex events in a persistent storage layer.

=== Databricks

Databricks is a unified, open analytics platform designed for building, deploying, sharing, and maintaining
enterprise-grade data, analytics, and AI solutions at scale. It integrates seamlessly with cloud storage and security in
your cloud account, managing and deploying cloud infrastructure on your behalf. Databricks is particularly noted for its
ability to connect various data sources to a single platform, facilitating the processing, storage, sharing, analysis,
modeling, and monetization of datasets. This platform is versatile, supporting a wide range of data tasks including data
processing scheduling and management, generating dashboards and visualizations, managing security and governance, and
supporting machine learning and generative AI solutions @databricks

The platform is built on top of Apache Spark, optimized for cloud environments, and offers scalability for both
small-scale and large-scale jobs. It supports multiple coding languages through a notebook interface, allowing
developers to build algorithms using Python, R, Scala, or SQL. Databricks enhances productivity by enabling instant
deployment of notebooks into production and provides a collaborative environment for data scientists, engineers, and
business analysts. It also ensures data reliability and scalability through Delta Lake and supports various frameworks,
libraries, scripting languages, tools, and IDEs

Databricks stands out for its flexibility across different ecosystems, including AWS, GCP, and Azure, and its commitment
to data reliability and scalability. It supports a wide array of frameworks and libraries, offers model lifecycle
management through MLflow, and enables hyperparameter tuning with Hyperopt. Additionally, Databricks integrates with
GitHub and Bitbucket, further enhancing its collaborative capabilities. The platform is recognized for its speed, being
reported to be 10x faster than other ETL solutions, and provides basic inbuilt visualizations to aid in data
interpretation

=== Cloud Native ingestion

Cloud-native ingestion technologies have evolved significantly over the years, driven by the need for real-time data processing and analytics across various industries. At the forefront of this evolution are Amazon Kinesis, Google Cloud Pub/Sub, and Azure Event Hubs, each offering unique capabilities tailored to different cloud environments and use cases.

Amazon Kinesis stands out for its comprehensive suite of real-time data streaming services, designed to handle everything from live video streams to log files. Its strength lies in its ability to ingest, process, and analyze streaming data in real time, making it ideal for applications ranging from real-time analytics to machine learning. Kinesis is deeply integrated with other AWS services, facilitating the creation of end-to-end data processing pipelines. Its scalability, performance, and robust security features make it a go-to choice for enterprises heavily invested in the AWS ecosystem. @kinesis

Google Cloud Pub/Sub is a messaging service that excels in scenarios requiring real-time event-driven architectures. It supports high-throughput and low-latency data ingestion, making it suitable for a wide array of applications, from chat and messaging systems to IoT device telemetry. Pub/Sub's integration with other Google Cloud services, such as Cloud Dataflow for data transformation and Cloud Functions for event-triggered computations, enhances its versatility. Its scalability and reliability, backed by a strong SLA, position it as a reliable choice for building resilient, real-time data processing systems. @gcp-pubsub

Azure Event Hubs serves as a central hub for big data pipelines, capable of receiving and processing millions of events per second. It is particularly well-suited for IoT solutions, where it can aggregate data from numerous devices before routing it to storage or analytics services. Azure Event Hubs' integration with Azure services, such as Azure Stream Analytics for real-time analytics and Azure Machine Learning for predictive modeling, makes it a powerful tool for developing sophisticated, data-driven applications. Its scalability, performance, and security features cater to the demands of modern, cloud-centric applications. @azure-event-hub

=== Microsoft Fabric

Microsoft Fabric is an innovative, end-to-end analytics and data platform designed to address the comprehensive needs of enterprises seeking a unified solution for data movement, processing, ingestion, transformation, real-time event routing, and report building. It consolidates a variety of services, including Data Engineering, Data Factory, Data Science, Real-Time Analytics, Data Warehouse, and Databases, into a single, seamlessly integrated platform. This integration eliminates the necessity for assembling services from multiple vendors, offering instead a user-friendly platform that simplifies analytics requirements. Operating on a Software as a Service (SaaS) model, Fabric brings about simplicity and integration to analytics solutions, leveraging OneLake for centralized data storage and embedding AI capabilities to enhance data processing and insights generation @fabric

Fabric's architecture is built to foster a highly integrated ecosystem of analytics services, promoting seamless data flow between different stages of the analytics pipeline. This integration reduces data silos and enhances efficiency, allowing enterprises to utilize their preferred analytics tools while keeping data in its current location. As a SaaS platform, Fabric handles infrastructure setup and maintenance, enabling organizations to focus on leveraging its analytics capabilities rather than managing the underlying infrastructure. It is designed to scale effortlessly to accommodate varying workloads, ensuring that enterprises can efficiently handle large volumes of data and analytic tasks without experiencing performance bottlenecks.

One of the key advantages of Microsoft Fabric is its comprehensive analytics suite, which covers everything from data movement to data science, real-time analytics, and business intelligence. This all-in-one solution simplifies the analytics workflow by eliminating the need to invest in and manage multiple disparate tools. Additionally, Fabric offers advanced data science capabilities, providing tools and resources for data scientists to perform complex data analysis, build machine learning models, and derive predictive insights. This supports data-driven innovation and optimization, making Fabric a compelling choice for enterprises looking to streamline their analytics processes and optimize data-driven decision-making

Finally, Fabric stands out for its user-friendly interface, making it accessible to both technical and non-technical employees. This democratization of data analytics across teams, combined with strong security protections and compliance certifications, positions Fabric as a secure, compliant, and cost-effective solution for enterprises. The platform's ability to connect to existing PaaS offerings and allow customers to upgrade at their own pace indicates its compatibility with evolving analytics strategies, marking an evolution of Microsoft's analytics solutions towards a simplified, unified SaaS offering

=== Summary

This table provides a high-level view of how each technology fits within the landscape of big data processing and storage. It's important to note that the capabilities of these technologies can vary significantly depending on the specific version, configuration, and use case. Additionally, many of these technologies can be combined or extended with other tools to achieve more complex or specialized requirements. @compendium

#table(
  columns: (1.4fr, 0.8fr, 1fr, 1fr, 1fr),
  align: center,
  table.header(
    [*Tech*], [*Batch*], [*Stream*], [*Storage*], [*Scalable*],
  ),
    [*Hadoop*], [Yes], [No], [Yes (HDFS)], [High],
    [*Kafka*], [Yes], [Yes], [Yes (Kafka Cluster)], [Very High],
    [*Storm*], [No], [Yes], [No], [High],
    [*Spark*], [Yes], [Yes], [No], [Very High],
    [*Flink*], [Yes], [Yes], [No], [High],
    [*Flume*], [Yes], [No], [Yes (Avro Sink)], [Medium],
    [*Cassandra*], [Yes], [No], [Yes], [High],
    [*MongoDB*], [Yes], [No], [Yes], [High],
    [*Esper*], [No], [Yes], [No], [Medium],
    [*Databricks*], [Yes], [Yes], [No], [High],
    [*Microsoft Fabric*], [Yes], [Yes], [Yes], [High],
    [*AWS Kinesis*], [Yes], [Yes], [No], [High],
    [*Azure Event Hubs*], [Yes], [Yes], [No], [High],
    [*GCP Pub/Sub*], [Yes], [Yes], [No], [High],

)

== Diving Deep in Architecture

=== Lambda Architecture

Lambda Architecture is a data processing framework designed to handle massive volumes of data efficiently by combining
batch processing and real-time stream processing techniques. This hybrid approach aims to address the challenges
associated with processing big data by providing a scalable, fault-tolerant, and low-latency system capable of
analyzing both historical and real-time data. As it is usual with real time data streaming, input data comes in the form
of Apache Kafka (generally), due to its fast times and low latency @marz @compendium @fundamentals-lambda-kappa

#figure(
    image("images/lambda.png"),
    caption: [
        Lambda Architecture
    ]
)

At its core, Lambda Architecture consists of three primary layers:

1. *Batch Layer*: This layer processes large volumes of historical data in batches. It stores the data in an
   immutable, append-only manner, ensuring a reliable historical record. Technologies like Apache Hadoop are
   commonly used for data ingestion and storage in this layer.

2. *Speed Layer*: Also known as the real-time or stream processing layer, it handles the processing of new, incoming
   data in near real-time. This layer complements the batch layer by reducing the latency in making data available for
   analysis. Stream processing engines such as Apache Storm, Hazelcast Jet, Apache Flink, and Apache Spark
   Streaming are often employed here.

3. *Serving Layer*: This layer is responsible for making the processed data accessible for querying. It incrementally
   indexes the latest batch views and the most recent data from the speed layer, allowing users to query both historical
   and real-time data. The serving layer can also reindex data to accommodate changes in requirements or to fix issues.
   Storing is also handled in this layer, most commonly using Apache Cassandra

The architecture is designed to balance several critical aspects of data processing, including latency, throughput, and
fault tolerance. By leveraging batch processing for comprehensive data analysis and real-time stream processing for
immediate insights, Lambda Architecture enables organizations to respond to data-driven opportunities and challenges
more effectively.

One of the key advantages of Lambda Architecture is its ability to handle high volumes of data across various sources,
making it suitable for applications ranging from ecommerce analytics to banking transactions and beyond. However, it's
worth noting that implementing Lambda Architecture can be complex due to the need for managing separate pipelines and
ensuring synchronization between them.

Overall, Lambda Architecture represents a powerful solution for organizations looking to leverage big data and
real-time analytics, offering a blend of historical depth and real-time responsiveness that is essential for competitive
advantage in today's data-driven world.

=== Kappa Architecture

The Kappa Architecture, introduced by Jay Kreps, co-founder of Confluent, represents a significant shift from
traditional batch processing architectures towards real-time data processing. It simplifies the data processing
pipeline by focusing exclusively on processing data in real-time, eliminating the need for separate batch and real-time
processing paths found in Lambda Architecture. This architecture is centered around the concept of an immutable data
log, where all data—historical and real-time—is ingested and stored in a centralized log, serving as the single source
of truth for continuous processing and analysis of data streams. @compendium @fundamentals-lambda-kappa

#figure(
    image("images/kappa.png"),
    caption: [
        Kappa Architecture
    ]
)


==== Core Components of Kappa Architecture

- *Immutable Data Log*: At the heart of Kappa Architecture is the idea that all data is treated as an unbounded stream
  of events. This approach ensures that data is continuously available for processing and analysis, regardless of when
  it was generated

- *Stream Ingestion*: Data from various sources is ingested into a stream processing system, such as Apache Kafka.
  Kafka plays a pivotal role in Kappa Architecture by providing a scalable and fault-tolerant infrastructure for
  ingesting, storing, and processing real-time data streams. It ensures the durability and reliability of the ingested
  events

- *Stream Processing*: Once ingested, the data is processed in real-time using stream processing frameworks like
  Apache Flink or Apache Spark Streaming. These frameworks allow for complex event processing, aggregations, and
  transformations on the streaming data, enabling real-time analytics and decision-making

- *Persistent Storage*: After processing, the events are stored in a fault-tolerant, scalable storage system, such
  as Apache Hadoop Distributed File System (HDFS), Apache Cassandra or cloud-based object storage. This storage
  acts as a data lake for long-term storage and potential future batch processing, although the emphasis remains on
  real-time processing

==== Advantages of Kappa Architecture

- *Real-time Processing*: Kappa Architecture enables the processing of data in real-time, allowing for immediate
  insights and decision-making. This is crucial for applications that require rapid response to changing data conditions

- *Scalability*: The architecture is highly scalable, capable of handling large volumes of data in real-time. This
  scalability is essential for supporting growing data volumes and increasing user base

- *Cost-effectiveness*: Since Kappa Architecture does not require a separate batch processing layer, it can be more
  cost-effective than Lambda Architecture. This is because it leverages a single technology stack for both real-time
  and batch processing workloads

- *Simplicity*: The architecture is simpler than Lambda Architecture, removing the complexity associated with
  maintaining separate systems for batch and real-time processing. This simplicity reduces operational overhead and
  increases maintainability

=== StreamCube

The StreamCube architecture is designed to facilitate online, multi-dimensional, and multi-level analysis of stream data, addressing the challenges posed by the massive volumes of data generated in real-time surveillance systems, telecommunications, and other dynamic environments. This architecture is built upon several key components and principles aimed at efficient and effective computation of stream cubes, which are essential for discovering high-level characteristics such as trends and outliers within the data. @streamcube

==== Core Techniques and Principles:

- *Tilted Time Frame Model*: This model introduces a multi-resolution approach to time-related data registration. Recent data are registered at finer resolutions, allowing for more granular analysis, while older data are registered at coarser resolutions, reducing the overall storage requirements and aligning with common data analysis tasks [2].

- *Critical Layers and Observation Layer*: Instead of materializing cuboids at all levels, the architecture maintains a limited number of critical layers. This approach enables flexible analysis based on the observation layer and minimal interesting layer concepts, optimizing the system's resources for efficient query execution [2].

- *Popular Path Algorithm*: The architecture employs an efficient stream data cubing algorithm that computes only the layers (cuboids) along a popular path, leaving other cuboids for query-driven, online computation. This method allows for the construction and maintenance of stream data cubes incrementally with a reasonable amount of memory, computation cost, and query response time [2].

==== Challenges Addressed:

- *Parallel Computation Based on Distributed Memory*: While many frameworks have addressed this challenge, StreamCube extends its capabilities to ensure efficient parallel computation across distributed systems [4].

- *Redundant Computation and Incremental Calculation Over Large Amounts of Historical Data*: By eliminating redundancy and grouping stream data into different nodes, StreamCube addresses the issue of redundant computation caused by time window shifts of different queries. It also tackles the difficulty of incremental calculation over vast amounts of historical data, enabling real-time computation of complex statistical metrics [4].

- *Complex Logic Decomposition*: StreamCube decomposes the calculation of complex logic into an incremental scheme, facilitating real-time computation. This approach allows for the implementation of real-time computation of several complex statistical metrics, such as variance, standard deviation, covariance, and K order central moment, among others [4].

- *Event Sequence Detection*: StreamCube faces the challenge of detecting event sequences based on stream data, especially those occurring across multiple dimensions or based on context. It addresses this by providing a fast dynamic data processing technology based on the incremental computation scheme, supporting the detection of user-defined event sequences [4].

=== A novel architecture

Additionally to the architectures before mentioned there is an architectural pattern rising which is to view each process in an ETL pipeline as a microservice. A microservice architecture is a design pattern where a big application or system is composed into several different chunks, each responsible for 1 and only 1 task. This leverages the single responsibility in the SOLID principles perfectly and makes the codebase easier to develop and maintain for a large team. @big-archive

In the sources @microservices the team covers how they implemented said design for a use case of smart ports and air quality monitoring and showed impressive results.

#figure(
    image("images/microservices.png"),
    caption: [
        Microservices Architecture
    ]
)

_Addendum: The design implemented is not exactly the same as the one in the diagram since the services used don't use same technologies but rather equivalent ones, however the core idea is the same._

Essentially what they achieved was to split the ETL process into several layers: Data Source Layer, Filtering Layer, Processing Layer and Serving Layer, each handling its respective tasks and possibly decomposing into several microservices, one for each subtask

== Conclusion

This is an overview of the current technologies and architectures that most of the data professionals use for real time data processing. Choosing the right one for the job can vary because of different factors like availability in your region, your team's capabilities or your specific use case, there's no silver bullet here.

#bibliography(
    "biblio.yaml",
    title: "References"
)

