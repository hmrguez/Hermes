As described in the New Architecture pdf, they propose a new architecture paradigm. Similar to
the [[Kappa Architecture]].

## Layers

1. **Integration**: gathers the data and forwards it to the next layer for processing. Data comes in the form of IoT
   devices, sensors, websites, etc. [[Apache Kafka]] can handle this layer
2. **Filtering**: data inputted needs to be cleansed in order to move on to avoid processing unnecessary data. In my
   opinion, Kafka can also handle this, so this layer is pretty much a symbolic layer
3. **Processing**: made with [[Apache Storm]] and Machine Learning.
4. **Storage**: since [[Apache Storm]] doesn't provide a file or storage system out of the box this needs to happen
   elsewhere. Suggestions include [[Apache Cassandra]], HDFS, Amazon, etc
5. **Presentation Layer**: data needs to be presented in a way that data analysts should do their task. Platforms like
   Power BI, Quicksight can create interactive dashboards with the data

## Verbose

 